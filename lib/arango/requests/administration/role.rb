module Arango
  module Requests
    module Administration
      class Role < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/server/role"

        code 200, :success
      end
    end
  end
end
