module Arango
  module Requests
    module Foxx
      class RunScript < Arango::Request
        request_method :post

        self.uri_template = '{/dbcontext}/_api/foxx/scripts/{name}'

        param :mount

        body_any
        
        code 200, :success
      end
    end
  end
end
