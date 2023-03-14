module Arango
  module Requests
    # Foxx Requests
    module Foxx
      # API: GET {/dbcontext}/_api/foxx/scripts
      class ListScripts < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/foxx/scripts'

        param :mount

        code 200, :success
      end
    end
  end
end
