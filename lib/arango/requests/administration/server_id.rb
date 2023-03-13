module Arango
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_admin/server/id
      class ServerId < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/server/id"

        code 200, :success
        code 500, "Server is not running in cluster mode!"
      end
    end
  end
end
