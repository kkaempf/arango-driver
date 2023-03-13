module Arango
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_admin/statistics
      class Statistics < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/statistics"

        code 200, :success
      end
    end
  end
end
