module Arango
  module Requests
    module User
      class Get < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/user/{user}'

        code 200, :success
        code 401, "No database access to the _system database!"
        code 403, "No server access!"
        code 404, "User does not exist!"
      end
    end
  end
end
