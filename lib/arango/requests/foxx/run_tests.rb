module Arango
  module Requests
    module Foxx
      class RunTests < Arango::Request
        request_method :post

        self.uri_template = '{/dbcontext}/_api/foxx/tests'

        param :mount, :required
        param :filter
        param :idiomatic
        param :reporter

        code 200, :success
      end
    end
  end
end
