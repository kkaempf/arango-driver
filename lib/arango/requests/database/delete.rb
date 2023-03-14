module Arango
  # Arango Requests
  module Requests
    # Database Requests
    module Database
      # API: DELETE {/dbcontext}/_api/database/{name}
      class Delete < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/database/{name}'

        code 200, :success
        code 400, "Database already exists or request paramaters invalid!"
        code 403, "Not executed within the _system database!"
        code 409, "Database already exists!"
      end
    end
  end
end
