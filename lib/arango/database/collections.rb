module Arango
  # Arango Database
  class Database
    # Arango Database Collections
    module Collections
      # Retrieves all collections from the database.
      # @param exclude_system [Boolean] Optional, default true, exclude system collections.
      # @return [Array<Arango::DocumentCollection>]
      def all_collections(exclude_system: true)
        Arango::DocumentCollection::Base.all(exclude_system: exclude_system, database: self)
      end
      def batch_all_collections(exclude_system: true)
        Arango::DocumentCollection::Base.batch_all(exclude_system: exclude_system, database: self)
      end

      # Creates a new collection.
      # @param name [String] The name of the collection.
      # @param type [Symbol] One of :document or :edge, the collection type, optional, default: :document.
      # @return [Arango::DocumentCollection] The instance of the collection created.
      def create_collection(name:, type: :document, is_system: false)
        case type
        when :document then Arango::DocumentCollection::Base.new(name: name, database: self, is_system: is_system).create
        when :edge then Arango::EdgeCollection::Base.new(name: name, database: self, is_system: is_system).create
        else raise "No such collection type #{type}"
        end
      end
      def batch_create_collection(name:, type: :document, is_system: false)
        case type
        when :document then Arango::DocumentCollection::Base.new(name: name, database: self, is_system: is_system).batch_create
        when :edge then Arango::EdgeCollection::Base.new(name: name, database: self, is_system: is_system).batch_create
        else raise "No such collection type #{type}"
        end
      end

      # Get collection from the database.
      # @param name [String] The name of the collection.
      # @return [Arango::Database]
      def get_collection(name:)
        Arango::DocumentCollection::Base.get(name: name, database: self)
      end
      def batch_get_collection(name)
        Arango::DocumentCollection::Base.batch_get(name: name, database: self)
      end
      alias fetch_collection get_collection
      alias retrieve_collection get_collection
      alias batch_fetch_collection batch_get_collection
      alias batch_retrieve_collection batch_get_collection

      # Instantiates a new collection.
      # @param name [String] The name of the collection.
      # @param type [Symbol] One of :document or :edge, the collection type, optional, default: :document.
      # @return [Arango::DocumentCollection::Base]
      def new_collection(name:, type: :document, is_system: false)
        case type
        when :document then Arango::DocumentCollection::Base.new(name: name, database: self, is_system: is_system).create
        when :edge then Arango::EdgeCollection::Base.new(name: name, database: self, is_system: is_system).create
        else raise "No such collection type #{type}"
        end
      end

      # Retrieves a list of all collections.
      # @param exclude_system [Boolean] Optional, default true, exclude system collections.
      # @return [Array<String>] List of collection names.
      def list_collections(exclude_system: true)
        Arango::DocumentCollection::Base.list_all(exclude_system: exclude_system, database: self)
      end
      def batch_list_collections(exclude_system: true)
        Arango::DocumentCollection::Base.batch_list_all(exclude_system: exclude_system, database: self)
      end

      # Removes a collection.
      # @param name [String] The name of the collection.
      # @return nil
      def delete_collection(name:)
        Arango::DocumentCollection::Base.delete(name: name, database: self)
      end
      def batch_delete_collection(name:)
        Arango::DocumentCollection::Base.batch_delete(name: name, database: self)
      end

      # Check if collection exists.
      # @param name [String] Name of the collection
      # @return [Boolean]
      def collection_exists?(name:, exclude_system: true)
        Arango::DocumentCollection::Base.any_exists?(name: name, database: self, exclude_system: exclude_system)
      end
      def batch_collection_exists?(name:, exclude_system: true)
        Arango::DocumentCollection::Base.batch_any_exists?(name: name, database: self, exclude_system: exclude_system)
      end
    end
  end
end
