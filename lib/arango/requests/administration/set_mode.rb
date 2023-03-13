module Arango
  module Requests
    # Administration Requests
    module Administration
      # API: PUT /_admin/server/mode
      class SetMode < Arango::Request
        self.request_method = :put

        self.uri_template = "/_admin/server/mode"

        body :mode, :required
        
        code 200, :success
        code 401, "Not authenticated or unsufficient permissions!"
      end
    end
  end
end
