module Arango
  # Arango Requests
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_admin/log/level
      class GetLogLevel < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/log/level"

        code 200, :success
        code 500, "Server out of memory!"
      end
    end
  end
end
