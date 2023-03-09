module Arango
  module Requests
    module Administration
      class Status < Arango::Request
        request_method :get

        self.uri_template = "/_admin/status"

        code 200, :success
      end
    end
  end
end
