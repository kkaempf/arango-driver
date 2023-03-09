module Arango
  module Requests
    module View
      class Rename < Arango::Request
        request_method :put

        self.uri_template = '{/dbcontext}/_api/view/{name}/rename'

        body :name, :required

        code 200, :success
        code 400, "View name is missing!"
        code 404, "View unknown!"
      end
    end
  end
end
