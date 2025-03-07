module Arango
  # Arango Requests
  module Requests
    # Database Requests
    module Database
      # API: GET {/dbcontext}/_api/database/current
      class GetInformation < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/database/current'

        code 200, :success
        code 400, "Request is invalid!"
        code 404, "Database could not be found!"
      end
    end
  end
end
