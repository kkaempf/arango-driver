module Arango
  # Arango Document
  module Document
    # Arango Document ClassMethods
    module ClassMethods
      #@!visibility private
      def self.extended(base)
      #@!visibility public
        def all (offset: 0, limit: nil, batch_size: nil, collection:)
          bind_vars = {}
          query = "FOR doc IN #{collection.name}"
          if limit && offset
            query << "\n LIMIT @offset, @limit"
            bind_vars[:offset] = offset
            bind_vars[:limit] = limit
          end
          raise Arango::Error.new "offset must be used with limit" if offset > 0 && !limit
          query << "\n RETURN doc"
          body = { query: query }
          unless bind_vars.empty?
            body[:bind_vars] = bind_vars
          end
          if batch_size
            body[:batch_size] = batch_size
          end
          result = Arango::Requests::Cursor::Create.execute(server: collection.server, body: body)
          result_proc = ->(result) { result.result.map { |doc_attr| Arango::Document::Base.new(attributes: doc_attr, collection: collection) }}
          final_result = result_proc.call(result)
          if result[:has_more]
            collection.instance_variable_set(:@cursor, result)
            collection.instance_variable_set(:@batch_proc, result_proc)
            unless batch_size
              while collection.has_more?
                b = collection.next_batch
                final_result += b if b
              end
            end
          end
          final_result
        end

        def list (offset: 0, limit: nil, batch_size: nil, collection:)
          bind_vars = {}
          query = "FOR doc IN #{collection.name}"
          if limit && offset
            query << "\n LIMIT @offset, @limit"
            bind_vars[:offset] = offset
            bind_vars[:limit] = limit
          end
          raise Arango::Error.new "offset must be used with limit" if offset && offset.to_i > 0 && !limit
          query << "\n RETURN doc._key"
          args = { db: collection.database.name }
          body = { query: query }
          unless bind_vars.empty?
            body[:bind_vars] = bind_vars
          end
          if batch_size
            body[:batch_size] = batch_size
          end
          result = Arango::Requests::Cursor::Create.execute(server: collection.server, args: args, body: body)
          result_proc = ->(b) { b.result }
          final_result = result_proc.call(result)
          if result[:has_more]
            collection.instance_variable_set(:@cursor, result)
            collection.instance_variable_set(:@batch_proc, result_proc)
            unless batch_size
              while result[:has_more]
                final_result += collection.next_batch
              end
            end
          end
          final_result
        end

        def exists? (key: nil, attributes: {}, match_rev: nil, collection:)
          document = _attributes_from_arg(attributes)
          document[:_key] = key if key
          headers = { }
          if document.key?(:_key) && document.key?(:_rev) && match_rev == true
            headers[:'If-Match'] = document[:_rev]
          elsif document.key?(:_key) && document.key?(:_rev) && match_rev == false
            headers[:'If-None-Match'] = document[:_rev]
          end
          args = { collection: collection.name, key: document[:_key] }
          begin
            Arango::Requests::Document::Head.execute(server: collection.server, args: args, headers: headers)
          rescue Error
            return false
          end
          true
        end

        def create_documents (documents, wait_for_sync: nil, collection:)
          documents = [documents] unless documents.is_a? Array
          documents = documents.map{ |d| _attributes_from_arg(d) }
          params = { returnNew: true }
          params[:waitForSync] = wait_for_sync unless wait_for_sync.nil?
          args = { collection: collection.name }
          result = Arango::Requests::Document::CreateMultiple.execute(server: collection.server, args: args, params: params, body: documents)
          result.map do |doc|
            # returnNew does not work for 'multiple'
            Arango::Document::Base.get(key: doc[:_key], collection: collection)
          end
        end

        def get (key: nil, attributes: {}, collection: nil, database: nil)
          document = _attributes_from_arg(attributes)
          document[:_key] = key if key
          if document.key?(:_key)
            args = {collection: collection.name, key: document[:_key] }
            result = Arango::Requests::Document::Get.execute(server: collection.server, args: args)
            Arango::Document::Base.new(attributes: result, collection: collection)
          else
            bind_vars = {}
            query = "FOR doc IN #{collection.name}"
            i = 0
            document.each do |k,v|
              i += 1
              query << "\n FILTER doc.@key#{i} == @value#{i}"
              bind_vars["key#{i}"] = k.to_s
              bind_vars["value#{i}"] = v
            end
            query << "\n LIMIT 1"
            query << "\n RETURN doc"
            database = collection.database unless database
            aql = AQL.new(query: query, database: database, bind_vars: bind_vars, block: ->(_, result) do
                            Arango::Document::Base.new(attributes: result.result.first, collection: collection) if result.result.first
                          end
                         )
            aql.request
          end
        end
        base.singleton_class.alias_method :fetch, :get
        base.singleton_class.alias_method :retrieve, :get

        # get documents by attribute(s)
        def get_documents (attributes, collection:)
          attributes = [attributes] unless attributes.is_a? Array
          attributes = attributes.map{ |a| _attributes_from_arg(a) }
          results = []
          args = { collection: collection.name }
          attributes.each do |attribute|
            if attribute.key?(:_key)
              args[:key] = attribute[:_key]
              result = Arango::Requests::Document::Get.execute(server: collection.server, args: args)
              results << Arango::Document::Base.new(attributes: result, collection: collection)
            else
              bind_vars = {}
              query = "FOR doc IN #{collection.name}"
              i = 0
              attribute.each do |k,v|
                i += 1
                query << "\n FILTER doc.@key#{i} == @value#{i}"
                bind_vars["key#{i}"] = k.to_s
                bind_vars["value#{i}"] = v
              end
              query << "\n RETURN doc"
              aql = AQL.new(query: query, database: collection.database, bind_vars: bind_vars, block: ->(_, result) do
                documents = []
                result.result.each do |r|
                  documents << Arango::Document::Base.new(attributes: r, collection: collection)
                end
                documents
              end
              )
              results += aql.request
            end
          end
          results
        end
        base.singleton_class.alias_method :fetch_documents, :get_documents
        base.singleton_class.alias_method :retrieve_documents, :get_documents

        def replace_documents (documents, ignore_revs: false, wait_for_sync: nil, collection:)
          documents = [documents] unless documents.is_a? Array
          documents = documents.map{ |d| _attributes_from_arg(d) }
          params = { returnNew: true, ignoreRevs: ignore_revs }
          params[:waitForSync] = wait_for_sync unless wait_for_sync.nil?
          args = { collection: collection.name }
          result = Arango::Requests::Document::ReplaceMultiple.execute(server: @server, args: args, params: params, body: documents)
          result.map do |doc|
            Arango::Document::Base.new(attributes: doc[:new], collection: collection)
          end
        end

        def update_documents (documents, ignore_revs: false, wait_for_sync: nil, merge_objects: nil, collection:)
          documents = [documents] unless documents.is_a? Array
          documents = documents.map{ |d| _attributes_from_arg(d) }
          params = { returnNew: true, ignoreRevs: ignore_revs }
          params[:waitForSync] = wait_for_sync unless wait_for_sync.nil?
          params[:mergeObjects] = merge_objects unless merge_objects.nil?
          args = { collection: collection.name }
          result = Arango::Requests::Document::UpdateMultiple.execute(server: @server, args: args, params: params, body: documents)
          result.map do |doc|
            Arango::Document::Base.new(attributes: doc[:new], collection: collection)
          end
        end

        def delete (key: nil, attributes: {}, ignore_revs: false, wait_for_sync: nil, collection:)
          document = _attributes_from_arg(attributes)
          document[:_key] = key if key
          params = { }
          params[:waitForSync] = wait_for_sync unless wait_for_sync.nil?
          headers = nil
          headers = { "If-Match": document[:_rev] } if !ignore_revs && document.key?(:_rev)
          args = {collection: collection.name, key: document[:_key]}
          Arango::Requests::Document::Delete.execute(server: collection.server, args: args, headers: headers, params: params)
        end

        def delete_documents (documents, ignore_revs: false, wait_for_sync: nil, collection:)
          documents = [documents] unless documents.is_a? Array
          documents = documents.map{ |d| _attributes_from_arg(d) }
          params = { }
          params[:waitForSync] = wait_for_sync unless wait_for_sync.nil?
          args = {collection: collection.name }
          Arango::Requests::Document::DeleteMultiple.execute(server: collection.server, args: args, params: params, body: documents)
        end

        private def _attributes_from_arg(arg)
          case arg
          when String then { _key: arg }
          when Hash
            arg.transform_keys!(&:to_sym)
            arg[:_id] = arg.delete(:id) if arg.key?(:id) && !arg.key?(:_id)
            arg[:_key] = arg.delete(:key) if arg.key?(:key) && !arg.key?(:_key)
            arg[:_rev] = arg.delete(:rev) if arg.key?(:rev) && !arg.key?(:_rev)
            arg.delete_if{|_,v| v.nil?}
            arg
          when Arango::Document::Mixin then arg.to_h
          when Arango::Result then arg.to_h
          else
            raise "Unknown arg type '#{arg.class}', must be String, Hash, Arango::Result or Arango::Document but was #{arg.class}"
          end
        end
      end
    end
  end
end
