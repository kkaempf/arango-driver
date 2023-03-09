module Arango
  module Requests
    module Administration
      class Version < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/version"

        param :details

        code 200, :success
      end
    end
  end
end
