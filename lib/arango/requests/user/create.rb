module Arango
  # Arango Requests
  module Requests
    # User Requests
    module User
      # API: POST {/dbcontext}/_api/user
      class Create < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/user'

        body :active
        body :extra
        body :passwd
        body :user, :required

        code 201, :success
        code 400, "JSON representation is malformed or mandatory data is missing from the request!"
        code 401, "No database access to the _system database!"
        code 403, "No server access!"
        code 409, "A user with the same name already exists!"
      end
    end
  end
end
