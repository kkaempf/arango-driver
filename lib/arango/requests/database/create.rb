module Arango
  # Arango Requests
  module Requests
    # Database Requests
    module Database
      # API: POST {/dbcontext}/_api/database
      class Create < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/database'

        body :name, :required
        body :options
        body :users

        code 201, :success
        code 400, "Database already exists or request paramaters invalid!"
        code 403, "Not executed within the _system database!"
        code 409, "duplicate database"
      end
    end
  end
end
