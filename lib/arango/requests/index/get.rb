module Arango
  module Requests
    module Index
      class Get < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/index/{collection}/{id}'

        code 200, :success
        code 404, "Index unknown!"
      end
    end
  end
end
