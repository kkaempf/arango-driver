module Arango
  module Requests
    # User Requests
    module User
      # API: GET {/dbcontext}/_api/user/{user}/database/
      class ListDatabases < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/user/{user}/database/'

        param :full

        code 200, :success
        code 400, "Wrong access privileges!"
        code 401, "No database access to the _system database!"
        code 403, "No server access!"
      end
    end
  end
end
