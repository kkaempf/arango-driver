module Arango
  # Arango Requests
  module Requests
    # AQL Requests
    module AQL
      # API: DELETE /_api/query/{id}
      # @param id [Integer]
      class KillQuery < Arango::Request
        self.request_method = :delete

        self.uri_template = "/_api/query/{id}"

        code 200, :success
        code 400, "Malformed request!"
        code 404, "Query not found!"
      end
    end
  end
end
