module Arango
  # Arango Database
  class Database
    # Arango Database EdgeCollections
    module EdgeCollections
      # Retrieves all edge collections from the database.
      # @param exclude_system [Boolean] Optional, default true, exclude system collections.
      # @return [Array<Arango::EdgeCollection>]
      def all_edge_collections(exclude_system: true)
        Arango::EdgeCollection::Base.all(exclude_system: exclude_system, database: self)
      end

      # Creates a new edge collection.
      # @param name [String] The name of the collection.
      # @return [Arango::DocumentCollection] The instance of the collection created.
      def create_edge_collection(name:)
        Arango::EdgeCollection::Base.new(name: name, database: self).create
      end

      # Get edge collection from the database.
      # @param name [String] The name of the collection.
      # @return [Arango::Database]
      def get_edge_collection(name:)
        Arango::EdgeCollection::Base.get(name: name, database: self)
      end
      alias fetch_edge_collection get_edge_collection
      alias retrieve_edge_collection get_edge_collection

      # Instantiates a new edge collection.
      # @param name [String] The name of the collection.
      # @return [Arango::DocumentCollection]
      def new_edge_collection(name:)
        Arango::EdgeCollection::Base.new(name: name, type: :edge, database: self)
      end

      # Retrieves a list of edge collections.
      # @param exclude_system [Boolean] Optional, default true, exclude system collections.
      # @return [Array<String>] List of collection names.
      def list_edge_collections(exclude_system: true)
        Arango::EdgeCollection::Base.list(exclude_system: exclude_system, database: self)
      end

      # Removes a edge collection.
      # @param name [String] The name of the collection.
      # @return nil
      def delete_edge_collection(name:)
        Arango::EdgeCollection::Base.drop(name: name, database: self)
      end

      # Check if edge collection exists.
      # @param name [String] Name of the collection
      # @return [Boolean]
      def edge_collection_exists?(name:, exclude_system: true)
        Arango::EdgeCollection::Base.exists?(name: name, database: self, exclude_system: exclude_system)
      end
    end
  end
end
