module Arango
  module Requests
    # User Requests
     module User
      # API: GET {/dbcontext}/_api/user/
      class List < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/user/'

        code 201, :success
        code 401, "No database access to the _system database!"
        code 403, "No server access!"
      end
    end
  end
end
