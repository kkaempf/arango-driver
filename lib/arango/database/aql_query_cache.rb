module Arango
  # Arango Database
  class Database
    # Arango Database AQLQueryCache
    module AQLQueryCache

      def clear_query_cache
        result = Arango::Requests::AQL::ClearQueryResultCache(server: @server)
        true
      end

      def get_query_cache
        result = Arango::Requests::AQL::QueryResultCacheEntries(server: @server)
        result.map { |entry| Arango::Result.new(entry) }
      end

      def query_cache_properties
        Arango::Requests::AQL::GetQueryResultCacheProperties(server: @server)
      end

      def set_query_cache_properties(props)
        body = props.to_h
        body.transform_keys! { |k| k.to_s.camelize(:lower).to_sym }
        Arango::Requests::AQL::SetQueryResultCacheProperties(server: @server, body: body)
      end
    end
  end
end
