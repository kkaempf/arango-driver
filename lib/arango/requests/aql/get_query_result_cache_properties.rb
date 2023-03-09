module Arango
  module Requests
    module AQL
      class GetQueryResultCacheProperties < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/query-cache/properties"

        code 200, :success
        code 400, "Malformed request!"
      end
    end
  end
end
