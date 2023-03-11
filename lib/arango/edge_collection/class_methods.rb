module Arango
  # Arango EdgeCollection
  module EdgeCollection
    # Arango EdgeCollection ClassMethods
    module ClassMethods
      def new(database: Arango.current_database, graph: nil,
              name:, id: nil, globally_unique_id: nil, is_system: false, status: nil, type: :edge,
              properties: {})
        case type
        when :document
          Arango::DocumentCollection::Base.new(database: database, graph: graph,
                                               name: name, id: nil, globally_unique_id: globally_unique_id, is_system: false, status: status, type: :document,
                                               properties: properties)
        when :edge
          super(database: database, graph: graph,
                name: name, id: id, globally_unique_id: globally_unique_id, status: status, type: :edge, is_system: is_system,
                properties: properties)
        else raise "unknown type"
        end
      end

      # Takes a hash and instantiates a Arango::EdgeCollection object from it.
      # @param collection_hash [Hash]
      # @return [Arango::EdgeCollection]
      def from_h(collection_hash, database: Arango.current_database)
        collection_hash = collection_hash.transform_keys! { |k| k.to_s.underscore.to_sym }
        collection_hash.merge!(database: database) unless collection_hash.key?(:database)
        if collection_hash.key?(:properties)
          collection_hash[:id] = collection_hash[:properties].delete(:id) if collection_hash[:properties].key?(:id)
          collection_hash[:name] = collection_hash[:properties].delete(:name) if collection_hash[:properties].key?(:name)
          collection_hash[:status] = collection_hash[:properties].delete(:status) if collection_hash[:properties].key?(:status)
          collection_hash[:type] = collection_hash[:properties].delete(:type) if collection_hash[:properties].key?(:type)
        end
        collection_hash[:type] = TYPES[collection_hash[:type]] if collection_hash[:type].is_a?(Integer)
        Arango::EdgeCollection::Base.new(**collection_hash)
      end

      # Takes a Arango::Result and instantiates a Arango::EdgeCollection object from it.
      # @param collection_result [Arango::Result]
      # @param properties_result [Arango::Result]
      # @return [Arango::EdgeCollection]
      def from_results(collection_result, properties_result, database: Arango.current_database)
        hash = collection_result ? {}.merge(collection_result.to_h) : {}
        hash[:properties] = properties_result
        from_h(hash, database: database)
      end

      # Retrieves all collections from the database.
      # @param exclude_system [Boolean] Optional, default true, exclude system collections.
      # @param database [Arango::Database]
      # @return [Array<Arango::EdgeCollection>]
      def all (exclude_system: true, database: Arango.current_database)
        args = { excludeSystem: exclude_system }
        result = Arango::Requests::Collection::ListAll.execute(server: database.server, params: query)
        result.result.map { |c| from_results({}, c.to_h, database: database) }
      end

      # Get collection from the database.
      # @param name [String] The name of the collection.
      # @param database [Arango::Database]
      # @return [Arango::EdgeCollection]
      def get (name:, database: Arango.current_database)
        args = { name: name }
        result = Arango::Requests::Collection::Get.execute(server: database.server, args: args)
        props = Arango::Requests::Collection::GetProperties.execute(server: database.server, args: args)
        from_results(result, props.raw_result, database: database)
      end

      # Retrieves a list of all collections.
      # @param exclude_system [Boolean] Optional, default true, exclude system collections.
      # @param database [Arango::Database]
      # @return [Array<String>] List of collection names.
      def list (exclude_system: true, database: Arango.current_database)
        args = { excludeSystem: exclude_system }
        result = Arango::Requests::Collection::ListAll.execute(server: database.server, args: args)
        result.result.select { |c| TYPES[c[:type]] == :edge }.map { |c| c[:name] }
      end

      # Removes a collection.
      # @param name [String] The name of the collection.
      # @param database [Arango::Database]
      # @return nil
      def delete (name:, database: Arango.current_database)
        args = { name: name }
        Arango::Requests::Collection::Delete.execute(server: database.server, args: args)
      end

      # Check if a edge collection exists.
      # @param name [String] Name of the collection
      # @param database [Arango::Database]
      # @return [Boolean]
      def exists? (name:, exclude_system: true, database: Arango.current_database)
        args = { excludeSystem: exclude_system }
        result = Arango::Requests::Collection::ListAll.execute(server: database.server, params: query)
        result.result.select { |c| TYPES[c[:type]] == :edge }.map { |c| c[:name] }.include?(name)
      end
    end
  end
end
