module Arango
  # Arango Requests
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_api/endpoint
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
