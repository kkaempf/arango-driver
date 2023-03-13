module Arango
  # Arango Requests
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_admin/server/mode
      class GetMode < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/server/mode"

        code 200, :success
      end
    end
  end
end
