module Arango
  module Requests
    module View
      class Delete < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/view/{name}'

        code 200, :success
        code 400, "View name is missing!"
        code 404, "View unknown!"
      end
    end
  end
end
