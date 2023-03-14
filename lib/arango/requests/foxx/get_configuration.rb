module Arango
  # Arango Requests
  module Requests
    # Foxx Requests
    module Foxx
      # API: GET {/dbcontext}/_api/foxx/configuration
      class GetConfiguration < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/foxx/configuration'

        param :mount, :required

        code 200, :success
      end
    end
  end
end
