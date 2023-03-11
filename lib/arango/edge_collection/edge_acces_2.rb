module Arango
  # Arango EdgeCollection
  module Collection
    # Arango EdgeCollection EdgeAccess
    module EdgeAccess
      # === GRAPH ===
      def graph=(graph)
        satisfy_module_or_nil?(graph, Arango::Graph::Mixin)
        if !graph.nil? && graph.database.name != @database.name
          raise Arango::Error.new err: :database_graph_no_same_as_collection_database,
                                  data: { graph_database_name: graph.database.name, collection_database_name:  @database.name}
        end
        @graph = graph
      end
      alias assign_graph graph=

      def vertex(name: nil, body: {}, rev: nil, from: nil, to: nil)
        if @type == :edge
          raise Arango::Error.new err: :is_a_edge_collection, data: {type:  @type}
        end
        if @graph.nil?
          Arango::Document::Base.new(name: name, body: body, rev: rev, collection: self)
        else
          Arango::Vertex.new(name: name, body: body, rev: rev, collection: self)
        end
      end

      def edge(name: nil, body: {}, rev: nil, from: nil, to: nil)
        if @type == :document
          raise Arango::Error.new err: :is_a_document_collection, data: {type:  @type}
        end
        if @graph.nil?
          Arango::Document::Base.new(name: name, body: body, rev: rev, collection: self)
        else
          Arango::Edge::Base.new(name: name, body: body, rev: rev, from: from, to: to,
                           collection: self)
        end
      end

      def edge_exists?

      end

      def edge(name: nil, body: {}, rev: nil, from: nil, to: nil)
        Arango::Document::Base.new(name: name, collection: self, body: body, rev: rev,
                             from: from, to: to)
      end

      def edges(type: "edge") # "path", "id", "key"
        @return_edge = false
        if type == "edge"
          @return_edge = true
          type = "key"
        end
        satisfy_category?(type, %w[path id key edge])
        body = { type: type, collection: @name }
        result = @database.request("PUT", "_api/simple/all-keys", body: body)

        @has_more_simple = result[:hasMore]
        @id_simple = result[:id]
        return result if return_directly?(result)
        return result[:result] unless @return_edge
        if @return_edge
          result[:result].map{|key| Arango::Document::Base.new(name: key, collection: self)}
        end
      end

      def insert_edge

      end

      def insert_edges

      end

      def replace_edge

      end

      def replace_edges(edge: {}, wait_for_sync: nil, ignore_revs: nil,
                            return_old: nil, return_new: nil)
        edge.each{|x| x = x.body if x.is_a?(Arango::Document)}
        query = {
          waitForSync: wait_for_sync,
          returnNew:   return_new,
          returnOld:   return_old,
          ignoreRevs:  ignore_revs
        }
        result = @database.request("PUT", "_api/edge/#{@name}", body: edge,
                                   query: query)
        return results if return_directly?(result)
        results.map.with_index do |result, index|
          body2 = result.clone
          if return_new == true
            body2.delete(:new)
            body2 = body2.merge(result[:new])
          end
          real_body = edge[index]
          real_body = real_body.merge(body2)
          Arango::Document::Base.new(name: result[:_key], collection: self, body: real_body)
        end
      end

      def update_edge

      end

      def update_edges(edge: {}, wait_for_sync: nil, ignore_revs: nil,
                           return_old: nil, return_new: nil, keep_null: nil, merge_objects: nil)
        edge.each{|x| x = x.body if x.is_a?(Arango::Document)}
        query = {
          waitForSync: wait_for_sync,
          returnNew:   return_new,
          returnOld:   return_old,
          ignoreRevs:  ignore_revs,
          keepNull:    keep_null,
          mergeObject: merge_objects
        }
        result = @database.request("PATCH", "_api/edge/#{@name}", body: edge,
                                   query: query, keep_null: keep_null)
        return results if return_directly?(result)
        results.map.with_index do |result, index|
          body2 = result.clone
          if return_new
            body2.delete(:new)
            body2 = body2.merge(result[:new])
          end
          real_body = edge[index]
          real_body = real_body.merge(body2)
          Arango::Document::Base.new(name: result[:_key], collection: self,
                               body: real_body)
        end
      end

      def destroy_edge

      end
      def destroy_edges(edge: {}, wait_for_sync: nil, return_old: nil,
                            ignore_revs: nil)
        edge.each{|x| x = x.body if x.is_a?(Arango::Document)}
        query = {
          waitForSync: wait_for_sync,
          returnOld:   return_old,
          ignoreRevs:  ignore_revs
        }
        @database.request("DELETE", "_api/edge/#{@id}", query: query, body: edge)
      end
    end
  end
end
