module Arango
  module Requests
    module Administration
      class StatisticsDescription < Arango::Request
        request_method :get

        self.uri_template = "/_admin/statistics-description"

        code 200, :success
      end
    end
  end
end
