module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module User
      class GetCollectionAccessLevel < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/user/{user}/database/{database}/{collection}'

        code 200, :success
        code 400, "Wrong access privileges!"
        code 401, "No database access to the _system database!"
        code 403, "No server access!"
      end
    end
  end
end
