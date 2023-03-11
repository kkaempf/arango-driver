module Arango
  # Arango Edge
  module Edge
    # Arango Edge ClassMethods
    module ClassMethods
      #@!visibility private
      def self.extended(base)
      #@!visibility public
        # returns Array of Edge
        def all (offset: 0, limit: nil, batch_size: nil, edge_collection:)
          bind_vars = {}
          query = "FOR doc IN #{edge_collection.name}"
          if limit && offset
            query << "\n LIMIT @offset, @limit"
            bind_vars[:offset] = offset
            bind_vars[:limit] = limit
          end
          raise Arango::Error.new err: "offset must be used with limit" if offset > 0 && !limit
          query << "\n RETURN doc"
          body = { query: query }
          unless bind_vars.empty?
            body[:bind_vars] = bind_vars
          end
          if batch_size
            body[:batch_size] = batch_size
          end
          result = Arango::Requests::Cursor::Create.execute(server: edge_collection.server, body: body)
          result_proc = ->(result) { result.result.map { |edge_attr| Arango::Edge::Base.new(attributes: edge_attr, edge_collection: edge_collection) }}
          final_result = result_proc.call(result)
          if result[:has_more]
            edge_collection.instance_variable_set(:@cursor, result)
            edge_collection.instance_variable_set(:@batch_proc, result_proc)
            unless batch_size
              while edge_collection.has_more?
                b = edge_collection.next_batch
                final_result += b if b
              end
            end
          end
          final_result
        end

        # returns Array of keys
        def list (offset: 0, limit: nil, batch_size: nil, edge_collection:)
          bind_vars = {}
          query = "FOR doc IN #{edge_collection.name}"
          if limit && offset
            query << "\n LIMIT @offset, @limit"
            bind_vars[:offset] = offset
            bind_vars[:limit] = limit
          end
          raise Arango::Error.new err: "offset must be used with limit" if offset > 0 && !limit
          query << "\n RETURN doc._key"
          body = { query: query }
          unless bind_vars.empty?
            body[:bind_vars] = bind_vars
          end
          if batch_size
            body[:batch_size] = batch_size
          end
          result = Arango::Requests::Cursor::Create.execute(server: edge_collection.server, body: body)
          result_proc = ->(result) { result.result }
          final_result = result_proc.call(result)
          if result[:has_more]
            edge_collection.instance_variable_set(:@cursor, result)
            edge_collection.instance_variable_set(:@batch_proc, result_proc)
            unless batch_size
              while edge_collection.has_more?
                b = edge_collection.next_batch
                final_result += b if b
              end
            end
          end
          final_result
        end

        def exists? (key: nil, attributes: {}, match_rev: nil, edge_collection:)
          edge = _attributes_from_arg(attributes)
          if key.nil?
            return !!self.get(key: key, attributes: attributes, edge_collection: edge_collection)
          end
          edge[:_key] = key
          headers = { }
          raise Arango::Error.new("Edge with key required!") unless edge.key?(:_key)
          if edge.key?(:_key) && edge.key?(:_rev) && match_rev == true
            headers[:'If-Match'] = edge[:_rev]
          elsif edge.key?(:_key) && edge.key?(:_rev) && match_rev == false
            headers[:'If-None-Match'] = edge[:_rev]
          end
          args = { collection: edge_collection.name, key: edge[:_key] }
          begin
            Arango::Requests::Document::Head.execute(server: edge_collection.server, args: args, headers: headers)
          rescue Error
            return false
          end
          true
        end

        def create_edges (edges, wait_for_sync: nil, edge_collection:)
          edges = [edges] unless edges.is_a? Array
          edges = edges.map{ |d| _attributes_from_arg(d) }
          params = { returnNew: true }
          params[:waitForSync] = wait_for_sync unless wait_for_sync.nil?
          args = { collection: edge_collection.name }
          result = Arango::Requests::Document::CreateMultiple.execute(server: edge_collection.server, args: args, params: params, body: edges)
          result.map do |edge|
            # returnNew does not work for 'multiple'
            Arango::Edge::Base.get(key: edge[:_key], edge_collection: edge_collection)
          end
        end

        def get (key: nil, attributes: {}, edge_collection:)
          edge = _attributes_from_arg(attributes)
          edge[:_key] = key if key
          if edge.key?(:_key)
            args = {collection: edge_collection.name, key: edge[:_key] }
            result = Arango::Requests::Document::Get.execute(server: edge_collection.server, args: args)
            Arango::Edge::Base.new(attributes: result, edge_collection: edge_collection)
          else
            bind_vars = {}
            query = "FOR doc IN #{edge_collection.name}"
            i = 0
            edge.each do |k,v|
              i += 1
              query << "\n FILTER doc.@key#{i} == @value#{i}"
              bind_vars["key#{i}"] = k.to_s
              bind_vars["value#{i}"] = v
            end
            query << "\n LIMIT 1"
            query << "\n RETURN doc"
            aql = AQL.new(query: query, database: edge_collection.database, bind_vars: bind_vars, block: ->(_, result) do
                            Arango::Edge::Base.new(attributes: result.result.first, edge_collection: edge_collection) if result.result.first
                          end
                         )
            aql.request
          end
        end

        def get_edges (edges, edge_collection:)
          edges = [edges] unless edges.is_a? Array
          edges = edges.map{ |d| _attributes_from_arg(d) }
          results = []
          result_edges = []
          args = { collection: edge_collection.name }
          edges.each do |edge|
            if edge.key?(:_key)
              args[:key] = edge[:_key]
              result = Arango::Requests::Document::Get.execute(server: edge_collection.server, args: args)
              results << result
              result_edges << Arango::Edge::Base.new(attributes: result, edge_collection: edge_collection)
            else
              bind_vars = {}
              query = "FOR doc IN #{edge_collection.name}"
              i = 0
              edge.each do |k,v|
                i += 1
                query << "\n FILTER doc.@key#{i} == @value#{i}"
                bind_vars["key#{i}"] = k.to_s
                bind_vars["value#{i}"] = v
              end
              query << "\n LIMIT 1"
              query << "\n RETURN doc"
              aql = AQL.new(query: query, database: edge_collection.database, bind_vars: bind_vars, block: ->(_, result) do
                              result_edges << Arango::Edge::Base.new(attributes: result.result.first, edge_collection: edge_collection) if result.result.first
                              result_edges
                            end
                           )
              results << aql.request
            end
          end
          results
        end
        base.singleton_class.alias_method :fetch_edges, :get_edges
        base.singleton_class.alias_method :retrieve_edges, :get_edges

        def find_edges_matching (attributes, edge_collection:)
          vars = _attributes_from_arg(attributes)
          results = []
          result_edges = []
          args = { collection: edge_collection.name }
          if vars.key?(:_key)
            args[:key] = vars[:_key]
            result = Arango::Requests::Document::Get.execute(server: edge_collection.server, args: args)
            results << result
            result_edges << Arango::Edge::Base.new(attributes: result, edge_collection: edge_collection)
          else
            bind_vars = {}
            query = "FOR doc IN #{edge_collection.name}"
            i = 0
            vars.each do |k,v|
              i += 1
              query << "\n FILTER doc.@key#{i} == @value#{i}"
              bind_vars["key#{i}"] = k.to_s
              bind_vars["value#{i}"] = v
            end
            query << "\n RETURN doc"
            aql = AQL.new(query: query, database: edge_collection.database, bind_vars: bind_vars, block: ->(_, result) do
                            result.result.each do |res|
                              result_edges << Arango::Edge::Base.new(attributes: res, edge_collection: edge_collection)
                              result_edges
                            end
                          end
                         )
            results += aql.request
          end
          results
        end

        def replace_edges (edges, ignore_revs: false, wait_for_sync: nil, edge_collection:)
          edges = [edges] unless edges.is_a? Array
          edges = edges.map{ |d| _attributes_from_arg(d) }
          params = { returnNew: true, ignoreRevs: ignore_revs }
          params[:waitForSync] = wait_for_sync unless wait_for_sync.nil?
          args = { collection: edge_collection.name }
          result = Arango::Requests::Document::ReplaceMultiple.execute(server: edge_collection.server, args: args, params: params, body: edges)
          result.map do |doc|
            Arango::Edge::Base.new(attributes: doc[:new], edge_collection: edge_collection)
          end
        end

        def update_edges (edges, ignore_revs: false, wait_for_sync: nil, merge_objects: nil, edge_collection:)
          edges = [edges] unless edges.is_a? Array
          edges = edges.map{ |d| _attributes_from_arg(d) }
          params = { returnNew: true, ignoreRevs: ignore_revs }
          params[:waitForSync] = wait_for_sync unless wait_for_sync.nil?
          params[:mergeObjects] = merge_objects unless merge_objects.nil?
          args = { collection: edge_collection.name }
          result = Arango::Requests::Document::UpdateMultiple.execute(server: edge_collection.server, args: args, params: params, body: edges)
          result.map do |doc|
            Arango::Edge::Base.new(attributes: doc[:new], edge_collection: edge_collection)
          end
        end

        def delete (key: nil, attributes: {}, ignore_revs: false, wait_for_sync: nil, edge_collection:)
          edge = _attributes_from_arg(attributes)
          edge[:_key] = key if key
          params = { }
          params[:waitForSync] = wait_for_sync unless wait_for_sync.nil?
          headers = nil
          headers = { "If-Match": edge[:_rev] } if !ignore_revs && edge.key?(:_rev)
          args = { collection: edge_collection.name, key: edge[:_key] }
          Arango::Requests::Document::Delete.execute(server: edge_collection.server, args: args, headers: headers, params: params)
        end

        def delete_edges (edges, ignore_revs: false, wait_for_sync: nil, edge_collection:)
          edges = [edges] unless edges.is_a? Array
          edges = edges.map{ |d| _attributes_from_arg(d) }
          params = { ignoreRevs: ignore_revs }
          params[:waitForSync] = wait_for_sync unless wait_for_sync.nil?
          args = { collection: edge_collection.name }
          Arango::Requests::Document::DeleteMultiple.execute(server: edge_collection.server, args: args, params: params, body: edges)
        end

        private def _attributes_from_arg(arg)
          case arg
          when String then { _key: arg }
          when Hash
            arg.transform_keys!(&:to_sym)
            arg[:_id] = arg.delete(:id) if arg.key?(:id) && !arg.key?(:_id)
            arg[:_key] = arg.delete(:key) if arg.key?(:key) && !arg.key?(:_key)
            arg[:_rev] = arg.delete(:rev) if arg.key?(:rev) && !arg.key?(:_rev)
            arg[:_from] = arg.delete(:from) if arg.key?(:from) && !arg.key?(:_from)
            arg[:_to] = arg.delete(:to) if arg.key?(:to) && !arg.key?(:_to)
            arg.delete_if{|_,v| v.nil?}
            arg
          when Arango::Edge::Mixin then arg.to_h
          when Arango::Result then arg.to_h
          else
            raise "Unknown arg type, must be String, Hash, Arango::Result or Arango::Edge::Mixin."
          end
        end
      end
    end
  end
end
