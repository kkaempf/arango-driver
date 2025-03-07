module Arango
  # Arango Requests
  module Requests
    # AQL Requests
    module AQL
      # API: POST /_api/aqlfunction
      class CreateFunction < Arango::Request
        self.request_method = :post

        self.uri_template = "/_api/aqlfunction"

        param :group

        body_any

        code 200, :success
        code 201, :success # created
        code 400, "Function name is malformed!"
        code 404, "Function does not exist!"
      end
    end
  end
end
