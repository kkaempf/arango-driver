module Arango
  # Arango Requests
  module Requests
    # AQL Requests
    module AQL
      # API: DELETE /_api/query/slow
      class DeleteSlowQueryList < Arango::Request
        self.request_method = :delete

        self.uri_template = "/_api/query/slow"

        code 200, :success
        code 400, "Malformed request!"
      end
    end
  end
end
