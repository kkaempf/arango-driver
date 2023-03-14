module Arango
  module Requests
    # Foxx Requests
    module Foxx
      # API: PUT {/dbcontext}/_api/foxx/configuration
      class ReplaceConfiguration < Arango::Request
        self.request_method = :put

        self.uri_template = '{/dbcontext}/_api/foxx/configuration'

        param :mount, :required

        body_any

        code 200, :success
      end
    end
  end
end
