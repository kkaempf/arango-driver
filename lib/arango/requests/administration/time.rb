module Arango
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_admin/time
      class Time < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/time"

        code 200, :success
      end
    end
  end
end
