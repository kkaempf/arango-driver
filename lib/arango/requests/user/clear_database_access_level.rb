module Arango
  module Requests
    module User
      class ClearDatabaseAccessLevel < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/user/{user}/database/{database}'

        code 202, :success
        code 400, "JSON representation is malformed!"
      end
    end
  end
end
