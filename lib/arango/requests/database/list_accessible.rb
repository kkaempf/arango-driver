module Arango
  module Requests
    module Database
      class ListAccessible < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/database/user'

        code 200, :success
        code 400, "Request is invalid!"
      end
    end
  end
end
