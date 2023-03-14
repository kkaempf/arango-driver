module Arango
  # Arango Requests
  module Requests
    # Foxx Requests
    module Foxx
      # API: GET {/dbcontext}/_api/foxx/dependencies
      class GetDependencies < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/foxx/dependencies'

        param :mount, :required

        code 200, :success
      end
    end
  end
end
