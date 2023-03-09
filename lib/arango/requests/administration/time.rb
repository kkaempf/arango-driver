module Arango
  module Requests
    module Administration
      class Time < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/time"

        code 200, :success
      end
    end
  end
end
