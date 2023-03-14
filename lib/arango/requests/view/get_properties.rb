module Arango
  # Arango Requests
  module Requests
    # View Requests
    module View
      # API: GET {/dbcontext}/_api/view/{name}/properties
      class GetProperties < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/view/{name}/properties'

        code 200, :success
        code 400, "View name is missing!"
        code 404, "View unknown!"
      end
    end
  end
end
