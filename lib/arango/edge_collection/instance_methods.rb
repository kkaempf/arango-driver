module Arango
  # Arango EdgeCollection
  module EdgeCollection
    # Arango EdgeCollection InstanceMethods
    module InstanceMethods

      # Instantiate a new collection.
      # For param description see the attributes descriptions. All params except name and database are optional.
      # @param name [String] The name of the collection.
      # @param type [Symbol]
      # @param database [Arango::Database]
      # @param status
      # @return [Arango::DocumentCollection]
      def initialize(database: Arango.current_database, graph: nil,
                     name:, id: nil, globally_unique_id: nil, is_system: false, status: nil, type: :edge,
                     properties: {})
        send(:database=, database) if database
        send(:graph=, graph) if graph
        @aql = nil
        @batch_proc = nil
        @id = id
        @globally_unique_id = globally_unique_id
        @is_system = is_system
        _set_name(name)
        @name_changed = false
        @original_name = name

        _set_status(status)
        _set_type(type)
        _set_properties(properties)
      end

      attr_accessor :database
      attr_reader :graph

      def method_missing(property, *args, &block)
        property_s = property.to_s.underscore
        property_y = property_s.to_sym
        return @properties[property_y] = args[0] if property_s.end_with?('=')
        return @properties[property_y] if @properties.key?(property_y)
        super(property, *args, &block)
      end

      # @return [String]
      attr_reader :id

      # If true, create a system collection. In this case collection-name should start with an underscore.
      # End users should normally create non-system collections only. API implementors may be required to create system collections in
      # very special occasions, but normally a regular collection will do. (The default is false)
      # Can only be set by calling the constructor with the is_system param.
      # @return [Boolean]
      attr_reader :is_system

      # The name of the collection.
      # @return [String]
      attr_reader :name

      # The collections ArangoDB object_id, not to be confused with the collections ruby object_id.
      # @return [String]
      def arango_object_id
        @properties[:object_id]
      end

      # Additional options for key generation. If specified, then key_options should be a Hash containing the following attributes:
      # - type: specifies the type of the key generator. The currently available generators are traditional, autoincrement, uuid and padded.
      # - allow_user_keys: if set to true, then it is allowed to supply own key values in the _key attribute of a document.
      #   If set to false, then the key generator will solely be responsible for generating keys and supplying own key values in the _key attribute
      #   of documents is considered an error.
      # - increment: increment value for autoincrement key generator. Not used for other key generator types.
      # - offset: Initial offset value for autoincrement key generator. Not used for other key generator types.
      # Can only be set by calling the constructor with the key_options param.
      # @return [Arango::Result]
      def key_options
        Arango::Result.new(@properties[:key_options])
      end

      # The status of the collection as symbol, one of:
      # - :unknown
      # - :new_born
      # - :unloaded
      # - :loaded
      # - :being_unloaded
      # - :deleted
      # - :loading
      # @return [Symbol]
      def status
        STATES[@status]
      end

      # The type of the collection to create. The following values for type are valid:
      #   - document collection, use the :document symbol
      #   - edge collection, use the :edge symbol
      # The default collection type is :document.
      # Can only be set by calling the constructor with the type param.
      # @return [Symbol]
      def type
        TYPES[@type]
      end

      def journal_size=(n)
        @journal_size_changed = true
        @properties[:journal_size] = n
      end

      def wait_for_sync=(n)
        @wait_for_sync_changed = true
        @properties[:wait_for_sync] = n
      end

      def name=(n)
        @name_changed = true
        _set_name(n)
      end

      def server
        @database.server
      end

      # Stores the collection in the database.
      # @return [Arango::DocumentCollection] self
      def create
        @name_changed = false
        @journal_size_changed = false
        @wait_for_sync_changed = false

        body = { name: @name, type: @type }

        @properties.each do |k, v|
          body[k.to_s.camelize(:lower).to_sym] = v unless v.nil?
        end

        if body[:keyOptions]
          body[:keyOptions].delete_if{|_,v| v.nil?}
          body[:keyOptions].transform_keys! { |key| key.to_s.camelize(:lower).to_sym }
        end

        enforce_replication_factor = body.delete(:enforceReplicationFactor)
        wait_for_sync_replication = body.delete(:waitForSyncReplication)

        params = nil
        if enforce_replication_factor || wait_for_sync_replication
          params = {}
          params[:enforceReplicationFactor] = enforce_replication_factor unless enforce_replication_factor.nil?
          params[:waitForSyncReplication] = wait_for_sync_replication unless wait_for_sync_replication.nil?
        end

        result = Arango::Requests::Collection::Create.execute(server: server, body: body, params: params)
        _update_attributes(result)
        self
      end

      # Deletes a collection.
      # @return [NilClass]
      def delete
        params = { isSystem: @is_system }
        args = { name: @name, type: @type }
        Arango::Requests::Collection::Delete.execute(server: server, args: args, params: params)
      end

      # Truncates a collection.
      # @return [Arango::DocumentCollection] self
      def truncate
        args = { name: @name, type: @type }
        Arango::Requests::Collection::Truncate.execute(server: server, args: args)
        self
      end

      # Counts the documents in a collection
      # @return [Integer]
      def size
        args = { name: @name, type: @type }
        Arango::Requests::Collection::Count.execute(server: server, args: args).count
      end
      alias count size
      alias length size

      # Fetch the statistics of a collection
      # @return [Hash]
      def statistics
        args = { name: @name, type: @type }
        result = Arango::Requests::Collection::Statistics.execute(server: server, args: args)
        Arango::Result.new(result.figures)
      end

      # Return the shard ids of a collection
      # Note: This method only works on a cluster coordinator.
      # @param details [Boolean] If set to true, the return value will also contain the responsible servers for the collections’ shards.
      # @return [Array, Hash]
      def shards(details: false)
        return nil unless @database.server.coordinator?
        args = { name: @name, type: @type }
        params = { details: details }
        result = Arango::Requests::Collection::Shards.execute(server: server, args: args, params: params)
      end

      # Retrieve the collections revision id
      # @return [String]
      def revision
        args = { name: @name, type: @type }
        Arango::Requests::Collection::Revision.execute(server: server, args: args).revision
      end

      # Returns a checksum for the specified collection
      # @param with_revisions [Boolean] Whether or not to include document revision ids in the checksum calculation, optional, default: false.
      # @param with_data [Boolean] Whether or not to include document body data in the checksum calculation, optional, default: false.
      def checksum (with_revisions: false, with_data: false)
        args = { name: @name, type: @type }
        params = {
          withRevisions: with_revisions,
          withData: with_data
        }
        Arango::Requests::Collection::Checksum.execute(server: server, args: args, params: params).checksum
      end

      # Loads a collection into ArangoDBs memory. Returns the collection on success.
      # @return [Arango::DocumentCollection] self
      def load_into_memory
        args = { name: @name, type: @type, count: false }
        result = Arango::Requests::Collection::Load.execute(server: server, args: args).status
        _set_status(result)
        self
      end

      # Unloads a collection into ArangoDBs memory. Returns the collection on success.
      # @return [Arango::DocumentCollection] self
      def unload_from_memory
        args = { name: @name, type: @type }
        result = Arango::Requests::Collection::Unload.execute(server: server, args: args).status
        _set_status(result)
        self
      end

      # Load Indexes into Memory
      # Note: For the time being this function is only useful on RocksDB storage engine, as in MMFiles engine all indexes are in memory anyways.
      # @return [Arango::DocumentCollection] self
      def load_indexes_into_memory
        if @database.server.rocksdb?
          args = { name: @name, type: @type }
          Arango::Requests::Collection::LoadIndexesIntoMemory.execute(server: server, args: args)
        end
        self
      end

      # Rotates the journal of a collection. Collection must have a journal.
      # Note: This method is specific for the MMFiles storage engine, and there it is not available in a cluster.
      # @return [Arango::DocumentCollection] self
      def rotate_journal
        if @database.server.mmfiles?
          args = { name: @name, type: @type }
          Arango::Requests::Collection::RotateJournal.execute(server: server, args: args)
        end
        self
      end

      # recalculates the document count of a collection
      # Note: This function is only useful on RocksDB storage engine.
      # @return [Arango::DocumentCollection] self
      def recalculate_count
        if @database.server.rocksdb?
          args = { name: @name, type: @type }
          Arango::Requests::Collection::RecalculateCount.execute(server: server, args: args)
        end
        self
      end

      # Reload collection properties and name from the database, reverting any changes.
      # @return [Arango::DocumentCollection] self
      def reload
        request_name = @name_changed ? @original_name : @name
        @name_changed = false
        @journal_size_changed = false
        @wait_for_sync_changed = false
        args = { name: request_name, type: @type }
        result = Arango::Requests::Collection::Get.execute(server: server, args: args)
        _update_attributes(result)
        self
      end
      alias refresh reload
      alias revert reload

      # Save changed collection properties and name changed, to the database.
      # Note: except for wait_for_sync, journal_size and name, collection properties cannot be changed once a collection is created.
      # @return [Arango::DocumentCollection] self
      def save
        requests = []
        args = { name: @name, type: @type }
        rename = nil
        if @name_changed
          args[:name] = @original_name
          @name_changed = false
          body = { name: @name }
          rename = Arango::Requests::Collection::Rename.execute(server: server, args: args, body: body)
          @original_name = @name
        end
        if @journal_size_changed || @wait_for_sync_changed
          body = {}
          body[:journalSize] = @journal_size if @journal_size_changed && @database.server.mmfiles?
          body[:waitForSync] = @wait_for_sync if @wait_for_sync_changed
          @journal_size_changed = false
          @wait_for_sync_changed = false
          result = Arango::Requests::Collection::SetProperties.execute(server: server, args: args, body: body)
          @journal_size = result.journal_size if result.key?(:journal_size)
          @wait_for_sync = result.wait_for_sync if result.key?(:wait_for_sync)
        end
        [rename, self]
      end
      alias update save

      # Request next batch from a batched request.
      # @return value depending on original batched request.
      def next_batch
        return unless has_more?
        result = @aql.next
        final_result = if @batch_proc
                         @batch_proc.call(result)
                       else
                         result
                       end
        unless @aql.has_more?
          @aql = nil
          @batch_proc = nil
        end
        final_result
      end

      # Check if more results are available for a betched request.
      # @return [Boolean]
      def has_more?
        return false unless @aql
        @aql.has_more?
      end

      private

      def _set_name(name)
        raise 'illegal_name' if name.include?('/') || name.include?('.')
        @name = name
      end

      def _set_status(s)
        if s.class == Symbol && STATES.include?(s)
          @status = STATES.index(s)
        elsif s.class == Integer && s >= 0 && s <= 6
          @status = s
        else
          @status = STATES[0]
        end
      end

      def _set_type(t)
        if t.class == Symbol && TYPES.include?(t)
          @type = TYPES.index(t)
          @type = 2 if @type < 2
        elsif t.class == Integer && t >= 2 && t <= 3
          @type = t
        else
          @type = 2
        end
      end

      def _update_attributes(result)
        hash = result.raw_result
        @id = hash.delete(:id)
        @is_system = hash.delete(:is_system)
        _set_name(hash.delete(:name))
        s = hash.delete(:status)
        _set_status(s) if s
        t = hash.delete(:type)
        _set_type(t) if t
        _set_properties(hash)
      end

      def _set_properties(properties)
        properties = if properties
                        properties.transform_keys! { |k| k.to_s.underscore.to_sym }
                        properties[:key_options].transform_keys! { |k| k.to_s.underscore.to_sym } if properties.key?(:key_options)
                        properties[:sharding_strategy].to_s.underscore.to_sym if properties.key?(:sharding_strategy)
                        properties
                      else
                        {}
                      end
        return @properties = properties unless @properties
        @properties.merge!(properties)
      end
    end
  end
end
