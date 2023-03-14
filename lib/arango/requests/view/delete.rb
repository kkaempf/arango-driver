module Arango
  # Arango Requests
  module Requests
    # View Requests
    module View
      # API: DELETE {/dbcontext}/_api/view/{name}
      class Delete < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/view/{name}'

        code 200, :success
        code 400, "View name is missing!"
        code 404, "View unknown!"
      end
    end
  end
end
