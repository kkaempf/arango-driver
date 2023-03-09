module Arango
  module Requests
    module AQL
      class DeleteFunction < Arango::Request
        request_method :delete

        self.uri_template = "/_api/aqlfunction/{name}"

        param :namespace

        code 200, :success
        code 400, "Function name malformed!"
      end
    end
  end
end
