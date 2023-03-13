module Arango
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_admin/routing/reload
      class ReloadRouting < Arango::Request
        self.request_method = :post

        self.uri_template = "/_admin/routing/reload"

        code 204, :success
      end
    end
  end
end
