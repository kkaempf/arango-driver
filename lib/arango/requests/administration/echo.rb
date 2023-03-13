module Arango
  # Arango Requests
  module Requests
    # Administration Requests
    module Administration
      # API: POST /_admin/echo
      class Echo < Arango::Request
        self.request_method = :post

        self.uri_template = "/_admin/echo"

        body_any

        code 200, :success
      end
    end
  end
end
