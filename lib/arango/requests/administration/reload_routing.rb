module Arango
  module Requests
    module Administration
      class ReloadRouting < Arango::Request
        request_method :post

        self.uri_template = "/_admin/routing/reload"

        code 204, :success
      end
    end
  end
end
