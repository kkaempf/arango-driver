module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module AQL
      class GetSlowQueryList < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/query/slow"

        code 200, :success
        code 400, "Malformed request!"
      end
    end
  end
end
