module Arango
  # Arango Requests
  module Requests
    # AQL Requests
    module AQL
      # API: GET /_api/query/properties
      class GetQueryTrackingProperties < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/query/properties"

        code 200, :success
        code 400, "Malformed request!"
      end
    end
  end
end
