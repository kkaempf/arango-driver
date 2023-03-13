module Arango
  # Arango Requests
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_api/engine
      class Engine < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/engine"

        code 200, :success
      end
    end
  end
end
