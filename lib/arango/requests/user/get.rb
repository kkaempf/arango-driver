module Arango
  # Arango Requests
  module Requests
    # User Requests
    module User
      # API: GET {/dbcontext}/_api/user/{user}
      class Get < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/user/{user}'

        code 200, :success
        code 401, "No database access to the _system database!"
        code 403, "No server access!"
        code 404, "User does not exist!"
      end
    end
  end
end
