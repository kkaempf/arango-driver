module Arango
  # Arango Database
  class Database
    # Arango Database DocumentCollections
    module DocumentCollections
      # Retrieves all document collections from the database.
      # @param exclude_system [Boolean] Optional, default true, exclude system collections.
      # @return [Array<Arango::DocumentCollection>]
      def all_document_collections(exclude_system: true)
        Arango::DocumentCollection::Base.all(exclude_system: exclude_system, database: self)
      end
      def batch_all_document_collections(exclude_system: true)
        Arango::DocumentCollection::Base.batch_all(exclude_system: exclude_system, database: self)
      end

      # Creates a new document collection.
      # @param name [String] The name of the collection.
      # @param is_system [Boolean] set true to create a system collection, defaults to false
      # @return [Arango::DocumentCollection::Base] The instance of the collection created.
      def create_document_collection(name:, type: :document, is_system: false)
        Arango::DocumentCollection::Base.new(name: name, database: self, is_system: is_system).create
      end
      def batch_create_document_collection(name:, is_system: false)
        Arango::DocumentCollection::Base.new(name: name, database: self, is_system: is_system).batch_create
      end

      # Get document collection from the database.
      # @param name [String] The name of the collection.
      # @return [Arango::Database]
      def get_document_collection(name:)
        Arango::DocumentCollection::Base.get(name: name, database: self)
      end
      def batch_get_document_collection(name:)
        Arango::DocumentCollection::Base.batch_get(name: name, database: self)
      end
      alias fetch_document_collection get_document_collection
      alias retrieve_document_collection get_document_collection
      alias batch_fetch_document_collection batch_get_document_collection
      alias batch_retrieve_document_collection batch_get_document_collection

      # Instantiates a new document collection.
      # @param name [String] The name of the collection.
      # @param type [Symbol] One of :document or :edge, the collection type, optional, default: :document.
      # @return [Arango::DocumentCollection::Base]
      def new_document_collection(name:, type: :document)
        Arango::DocumentCollection::Base.new(name: name, type: type, database: self)
      end

      # Retrieves a list of document collections.
      # @param exclude_system [Boolean] Optional, default true, exclude system collections.
      # @return [Array<String>] List of collection names.
      def list_document_collections(exclude_system: true)
        Arango::DocumentCollection::Base.list(exclude_system: exclude_system, database: self)
      end
      def batch_list_document_collections(exclude_system: true)
        Arango::DocumentCollection::Base.batch_list(exclude_system: exclude_system, database: self)
      end

      # Removes a document collection.
      # @param name [String] The name of the collection.
      # @return nil
      def drop_document_collection(name:)
        Arango::DocumentCollection::Base.drop(name: name, database: self)
      end
      def batch_drop_document_collection(name:)
        Arango::DocumentCollection::Base.batch_drop(name: name, database: self)
      end
      alias delete_document_collection drop_document_collection
      alias destroy_document_collection drop_document_collection
      alias batch_delete_document_collection batch_drop_document_collection
      alias batch_destroy_document_collection batch_drop_document_collection

      # Check if document collection exists.
      # @param name [String] Name of the collection
      # @return [Boolean]
      def document_collection_exists?(name:, exclude_system: true)
        Arango::DocumentCollection::Base.exists?(name: name, database: self, exclude_system: exclude_system)
      end
      def batch_document_collection_exists?(name:, exclude_system: true)
        Arango::DocumentCollection::Base.batch_exists?(name: name, database: self, exclude_system: exclude_system)
      end
    end
  end
end
