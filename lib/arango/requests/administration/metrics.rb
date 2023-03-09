module Arango
  module Requests
    module Administration
      class Metrics < Arango::Request
        request_method :get

        self.uri_template = "/_admin/metrics"

        code 200, :success
        code 405, "Metrics API disabled!"
      end
    end
  end
end
