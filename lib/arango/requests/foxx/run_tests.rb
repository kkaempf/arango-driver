module Arango
  module Requests
    # Foxx Requests
    module Foxx
      # API: POST {/dbcontext}/_api/foxx/tests
      class RunTests < Arango::Request
        self.request_method = :post

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
