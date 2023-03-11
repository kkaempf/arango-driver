module Arango
  # Arango Database
  class Database
    # Arango Database SystemCollections
    module SystemCollections
      # Retrieves all collections from the database.
      # @param exclude_system [Boolean] Optional, default true, exclude system collections.
      # @return [Array<Arango::DocumentCollection>]
      def all_system_collections(exclude_system: true)
        Arango::DocumentCollection.all(exclude_system: exclude_system, database: self)
      end
      def batch_all_system_collections(exclude_system: true)
        Arango::DocumentCollection.batch_all(exclude_system: exclude_system, database: self)
      end

      # Creates a new collection.
      # @param name [String] The name of the collection.
      # @param type [Symbol] One of :document or :edge, the collection type, optional, default: :document.
      # @return [Arango::DocumentCollection] The instance of the collection created.
      def create_system_collection(name, type: :document, is_system: false)
        Arango::DocumentCollection.new(name, type: type, database: self, is_system: is_system).create
      end
      def batch_create_system_collection(name, type: :document, is_system: false)
        Arango::DocumentCollection.new(name, type: type, database: self, is_system: is_system).batch_create
      end

      # Creates a new edge collection.
      # @param name [String] The name of the collection.
      # @return [Arango::DocumentCollection] The instance of the collection created.
      def create_edge_system_collection(name)
        Arango::EdgeCollection.new(name, type: :edge, database: self).create
      end
      def batch_create_edge_system_collection(name)
        Arango::EdgeCollection.new(name, type: :edge, database: self).batch_create
      end

      # Get collection from the database.
      # @param name [String] The name of the collection.
      # @return [Arango::Database]
      def get_system_collection(name)
        Arango::DocumentCollection.get(name, database: self)
      end
      def batch_get_system_collection(name)
        Arango::DocumentCollection.batch_get(name, database: self)
      end
      alias fetch_system_collection get_system_collection
      alias retrieve_system_collection get_system_collection
      alias batch_fetch_system_collection batch_get_system_collection
      alias batch_retrieve_system_collection batch_get_system_collection

      # Instantiates a new collection.
      # @param name [String] The name of the collection.
      # @param type [Symbol] One of :document or :edge, the collection type, optional, default: :document.
      # @return [Arango::DocumentCollection]
      def new_system_collection(name, type: :document)
        Arango::DocumentCollection.new(name, type: type, database: self)
      end

      # Instantiates a new edge collection.
      # @param name [String] The name of the collection.
      # @return [Arango::DocumentCollection]
      def new_edge_system_collection(name)
        Arango::DocumentCollection.new(name, type: :edge, database: self)
      end

      # Retrieves a list of all collections.
      # @param exclude_system [Boolean] Optional, default true, exclude system collections.
      # @return [Array<String>] List of collection names.
      def list_system_collections(exclude_system: true)
        Arango::DocumentCollection.list(exclude_system: exclude_system, database: self)
      end
      def batch_list_system_collections(exclude_system: true)
        Arango::DocumentCollection.batch_list(exclude_system: exclude_system, database: self)
      end

      # Removes a collection.
      # @param name [String] The name of the collection.
      # @return nil
      def drop_system_collection(name)
        Arango::DocumentCollection.drop(name, database: self)
      end
      def batch_drop_system_collection(name)
        Arango::DocumentCollection.batch_drop(name, database: self)
      end
      alias delete_system_collection drop_system_collection
      alias destroy_system_collection drop_system_collection
      alias batch_delete_system_collection batch_drop_system_collection
      alias batch_destroy_system_collection batch_drop_system_collection

      # Check if collection exists.
      # @param name [String] Name of the collection
      # @return [Boolean]
      def system_collection_exists?(name, exclude_system: true)
        Arango::DocumentCollection.exists?(name, database: self, exclude_system: exclude_system)
      end
      def batch_system_collection_exists?(name, exclude_system: true)
        Arango::DocumentCollection.batch_exists?(name, database: self, exclude_system: exclude_system)
      end
    end
  end
end
