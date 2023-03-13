module Arango
  module Requests
    # AQL Requests
    module AQL
      # API: POST /_api/query
      class Parse < Arango::Request
        self.request_method = :post

        self.uri_template = "/_api/query"

        body :query, :required

        code 200, :success
        code 400, "Malformed request or parse error!"
      end
    end
  end
end
