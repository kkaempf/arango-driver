module Arango
  module Requests
    module Administration
      class GetMode < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/server/mode"

        code 200, :success
      end
    end
  end
end
