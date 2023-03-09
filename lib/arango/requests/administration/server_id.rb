module Arango
  module Requests
    module Administration
      class ServerId < Arango::Request
        request_method :get

        self.uri_template = "/_admin/server/id"

        code 200, :success
        code 500, "Server is not running in cluster mode!"
      end
    end
  end
end
