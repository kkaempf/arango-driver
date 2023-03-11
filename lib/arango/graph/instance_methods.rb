module Arango
  # Arango Graph
  module Graph
    # Arango Graph InstanceMethods
    module InstanceMethods

      # Instantiate a new collection.
      # For param description see the attributes descriptions. All params except name are optional.
      # @param name [String] The name of the collection.
      # @param database [Arango::Database], defaults to Arango.current_database
      # @param edge_definitions [Array] of edge definitions
      # @param is_smart [Boolean], optional, defaults to false
      # @param properties [Hash]
      # @return [Arango::Graph]
      def initialize(database: Arango.current_database,
                     name:, edge_definitions: [], is_smart: false,
                     properties: {})
        @attributes = { name: name, edge_definitions: edge_definitions }
        @changed_attributes = {}
        send(:database=, database)
        @aql = nil
        @batch_proc = nil
        _set_name(name)
        @name_changed = false
        @original_name = name
        @edge_definitions = edge_definitions
        @orphan_collections = []
        _set_properties(properties)
      end

      attr_accessor :database

      def id
        @changed_attributes[:_id] || @attributes[:_id]
      end

      def id=(i)
        @changed_attributes[:_id] = i
      end

      def name
        @changed_attributes[:name] || @attributes[:name]
      end

      def name=(n)
        @name_changed = true
        _set_name(n)
      end

      def revision
        @properties[:_rev]
      end

      def to_h
        @attributes.delete_if{|_,v| v.nil?}
      end

      def wait_for_sync=(n)
        @wait_for_sync_changed = true
        @properties[:wait_for_sync] = n
      end

      # Stores the graph in the database.
      # @return [Arango::DocumentCollection] self
      def create
        @name_changed = false
        @wait_for_sync_changed = false

        body = {}.merge(@attributes)
        body.merge!(@changed_attributes)

        @properties.each do |k, v|
          body[:options][k.to_s.camelize(:lower)] = v unless v.nil?
        end

        params = {}
        if @wait_for_sync_changed
          params[:waitForSync] = @wait_for_sync
        end
        result = Arango::Requests::Graph::Create.execute(server: @database.server, body: body, params: params)
        _update_attributes(result.graph)
        self
      end

      # Deletes a graph.
      # @return [NilClass]
      def delete
        args = { graph: @name }
        Arango::Requests::Graph::Delete.execute(server: @database.server, args: args)
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

      def _update_attributes(result)
        hash = result
        @id = hash.delete(:id)
        _set_name(hash.delete(:name))
        _set_properties(hash)
      end

      def _set_properties(properties)
        properties = if properties
                       properties.transform_keys { |k| k.to_s.underscore.to_sym }
                     else
                       {}
                     end
        return @properties = properties unless @properties
        @properties.merge!(properties)
      end

    end
  end
end
