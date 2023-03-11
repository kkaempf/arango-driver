module Arango
  # Arango Graph
  module Graph
    # Arango Graph EdgeAccess
    module EdgeAccess
      def edge_collection

      end

      def edge_collections
        result = request("GET", "edge", key: :collections)
        return result if @database.server.async != false
        return result if return_directly?(result)
        result.map{|r| Arango::DocumentCollection.new(database: @database, name: r, type: :edge)}
      end

      def edge_definitions

      end

      def add_edge_definition(collection:, from:, to:)
        satisfy_module_or_string?(collection, Arango::DocumentCollection::Mixin)
        satisfy_module_or_string?(from, Arango::Document::Mixin)
        satisfy_module_or_string?(to, Arango::Document::Mixin)
        from = [from] unless from.is_a?(Array)
        to = [to] unless to.is_a?(Array)
        body = {}
        body[:collection] = collection.is_a?(String) ? collection : collection.name
        body[:from] = from.map{|f| f.is_a?(String) ? f : f.name }
        body[:to] = to.map{|t| t.is_a?(String) ? t : t.name }
        result = request("POST", "edge", body: body, key: :graph)
        return_element(result)
      end

      def replace_edge_definition(collection:, from:, to:)
        satisfy_class?(collection, [String, Arango::DocumentCollection])
        satisfy_class?(from, [String, Arango::DocumentCollection], true)
        satisfy_class?(to, [String, Arango::DocumentCollection], true)
        from = [from] unless from.is_a?(Array)
        to = [to] unless to.is_a?(Array)
        body = {}
        body[:collection] = collection.is_a?(String) ? collection : collection.name
        body[:from] = from.map{|f| f.is_a?(String) ? f : f.name }
        body[:to] = to.map{|t| t.is_a?(String) ? t : t.name }
        result = request("PUT", "edge/#{body[:collection]}", body: body, key: :graph)
        return_element(result)
      end

      def remove_edge_definition(collection:, dropCollection: nil)
        satisfy_class?(collection, [String, Arango::DocumentCollection])
        query = {dropCollection: dropCollection}
        collection = collection.is_a?(String) ? collection : collection.name
        result = request("DELETE", "edge/#{collection}", query: query, key: :graph)
        return_element(result)
      end
    end
  end
end
