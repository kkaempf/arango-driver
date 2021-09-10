module Arango
  module Requests
    module Administration
      class Version < Arango::Request
        request_method :get

        uri_template "/_admin/version"

        param :details

        code 200, :success
      end
    end
  end
end
