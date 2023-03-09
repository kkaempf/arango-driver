module Arango
  module Requests
    module User
      class SetCollectionAccessLevel < Arango::Request
        self.request_method = :put

        self.uri_template = '{/dbcontext}/_api/user/{user}/database/{database}/{collection}'

        body :grant

        code 200, :success
        code 400, "Wrong access privileges!"
        code 401, "No database access to the _system database!"
        code 403, "No server access!"
      end
    end
  end
end
