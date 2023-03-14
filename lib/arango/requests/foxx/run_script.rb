module Arango
  module Requests
    # Foxx Requests
    module Foxx
      # API: POST {/dbcontext}/_api/foxx/scripts/{name}
      class RunScript < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/foxx/scripts/{name}'

        param :mount

        body_any
        
        code 200, :success
      end
    end
  end
end
