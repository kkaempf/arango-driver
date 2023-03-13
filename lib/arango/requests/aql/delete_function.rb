module Arango
  # Arango Requests
  module Requests
    # AQL Requests
    module AQL
      # API: DELETE /_api/aqlfunction/{name}
      # @param name [String]
      class DeleteFunction < Arango::Request
        self.request_method = :delete

        self.uri_template = "/_api/aqlfunction/{name}"

        param :namespace

        code 200, :success
        code 400, "Function name malformed!"
      end
    end
  end
end
