module Arango
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_admin/metrics
      class Metrics < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/metrics"

        code 200, :success
        code 405, "Metrics API disabled!"
      end
    end
  end
end
