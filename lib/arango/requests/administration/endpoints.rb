module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Administration
      class Endpoints < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/endpoint"

        code 200, :success
        code 400, "The action is not carried out in the system database!"
        code 405, "An unsupported HTTP method!"

      end
    end
  end
end
