module Arango
  module Requests
    module AQL
      class Parse < Arango::Request
        request_method :post

        self.uri_template = "/_api/query"

        body :query, :required

        code 200, :success
        code 400, "Malformed request or parse error!"
      end
    end
  end
end
