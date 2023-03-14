module Arango
  # Arango Requests
  module Requests
    # Database Requests
    module Database
      # API: GET {/dbcontext}/_api/database/user
      class ListAccessible < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/database/user'

        code 200, :success
        code 400, "Request is invalid!"
      end
    end
  end
end
