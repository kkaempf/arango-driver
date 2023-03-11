module Arango
  # Arango DocumentCollection
  module DocumentCollection
    # Arango DocumentCollection Documents
    module Documents
      def new_document(key: nil, attributes: {}, wait_for_sync: nil)
        Arango::Document::Base.new(key: key, attributes: attributes, collection: self, wait_for_sync: wait_for_sync)
      end

      def create_document(key: nil, attributes: {}, wait_for_sync: nil)
        Arango::Document::Base.new(key: key, attributes: attributes, collection: self, wait_for_sync: wait_for_sync).create
      end

      def create_documents(array_of_attributes_hashes, wait_for_sync: nil)
        Arango::Document::Base.create_documents(array_of_attributes_hashes, collection: self, wait_for_sync: wait_for_sync)
      end

      def document_exists?(key: nil, attributes: {}, match_rev: nil)
        Arango::Document::Base.exists?(key: key, attributes: attributes, match_rev: match_rev, collection: self)
      end

      def get_document(key: nil, attributes: {})
        Arango::Document::Base.get(key: key, attributes: attributes, collection: self)
      end
      alias fetch_document get_document
      alias retrieve_document get_document

      def get_documents(keys)
        Arango::Document::Base.get_documents(keys, collection: self)
      end
      alias fetch_documents get_documents
      alias retrieve_documents get_documents

      def all_documents(offset: 0, limit: nil, batch_size: nil)
        Arango::Document::Base.all(offset: offset, limit: limit, batch_size: batch_size, collection: self)
      end

      def list_documents(offset: 0, limit: nil, batch_size: nil)
        Arango::Document::Base.list(offset: offset, limit: limit, batch_size: batch_size, collection: self)
      end

      def replace_document(document)
        Arango::Document::Base.replace(document)
      end

      def replace_documents(documents_array, wait_for_sync: nil, ignore_revs: nil, return_old: nil, return_new: nil)
        Arango::Document::Base.replace_documents(documents_array, wait_for_sync: wait_for_sync, ignore_revs: ignore_revs,
                                                 return_old: return_old, return_new: return_new)
      end

      def save_document(document)
        Arango::Document::Base.save(document)
      end
      alias update_document save_document

      def save_documents(documents_array, wait_for_sync: nil, ignore_revs: nil)
        Arango::Document::Base.save_documents(documents_array, wait_for_sync: wait_for_sync, ignore_revs: ignore_revs)
      end
      alias update_documents save_documents

      def delete_document(key: nil, attributes: {})
        Arango::Document::Base.delete(key: key, attributes: attributes, collection: self)
      end

      def delete_documents(documents_array)
        Arango::Document::Base.delete_documents(documents_array, collection: self)
      end
    end
  end
end
