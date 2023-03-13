module Arango
  module Requests
    # AQL Requests
    module AQL
      # API: GET /_api/query-cache/entries
      class QueryResultCacheEntries < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/query-cache/entries"

        code 200, :success
        code 400, "Malformed request!"
      end
    end
  end
end
