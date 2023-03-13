module Arango
  # Arango Requests
  module Requests
    # AQL Requests
    module AQL
      # API: DELETE /_api/query-cache
      class ClearQueryResultCache < Arango::Request
        self.request_method = :delete

        self.uri_template = "/_api/query-cache"

        param :namespace

        code 200, :success
        code 400, "Malformed request!"
      end
    end
  end
end
