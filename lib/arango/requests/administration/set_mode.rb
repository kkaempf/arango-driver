module Arango
  module Requests
    module Administration
      class SetMode < Arango::Request
        request_method :put

        self.uri_template = "/_admin/server/mode"

        body :mode, :required
        
        code 200, :success
        code 401, "Not authenticated or unsufficient permissions!"
      end
    end
  end
end
