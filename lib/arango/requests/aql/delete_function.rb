module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module AQL
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
