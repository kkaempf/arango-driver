module Arango
  module Requests
    module Administration
      class Statistics < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/statistics"

        code 200, :success
      end
    end
  end
end
