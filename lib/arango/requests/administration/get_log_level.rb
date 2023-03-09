module Arango
  module Requests
    module Administration
      class GetLogLevel < Arango::Request
        request_method :get

        self.uri_template = "/_admin/log/level"

        code 200, :success
        code 500, "Server out of memory!"
      end
    end
  end
end
