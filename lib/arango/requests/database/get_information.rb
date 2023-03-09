module Arango
  module Requests
    module Database
      class GetInformation < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/database/current'

        code 200, :success
        code 400, "Request is invalid!"
        code 404, "Database could not be found!"
      end
    end
  end
end
