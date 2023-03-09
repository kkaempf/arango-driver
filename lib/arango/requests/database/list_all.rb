module Arango
  module Requests
    module Database
      class ListAll < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/database'

        code 200, :success
        code 400, "Request is invalid!"
        code 403, "Not executed within the _system database!"
      end
    end
  end
end
