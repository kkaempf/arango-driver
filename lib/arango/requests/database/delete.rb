module Arango
  module Requests
    module Database
      class Delete < Arango::Request
        request_method :delete

        self.uri_template = '{/dbcontext}/_api/database/{name}'

        code 200, :success
        code 400, "Database already exists or request paramaters invalid!"
        code 403, "Not executed within the _system database!"
        code 409, "Database already exists!"
      end
    end
  end
end
