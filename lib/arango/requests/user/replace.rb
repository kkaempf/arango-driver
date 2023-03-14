module Arango
  module Requests
    # User Requests
    module User
      # API: PUT {/dbcontext}/_api/user/{user}
      class Replace < Arango::Request
        self.request_method = :put

        self.uri_template = '{/dbcontext}/_api/user/{user}'

        body :passwd
        body :active
        body :extra

        code 200, :success
        code 400, "JSON malformed or mandatory data is missing!"
        code 401, "No database access to the _system database!"
        code 403, "No server access!"
        code 404, "User does not exist!"
      end
    end
  end
end
