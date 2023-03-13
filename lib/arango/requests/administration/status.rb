module Arango
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_admin/status
      class Status < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/status"

        code 200, :success
      end
    end
  end
end
