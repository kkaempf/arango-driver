module Arango
  module Requests
    # Foxx Requests
    module Foxx
      # API: DELETE {/dbcontext}/_api/foxx
      class Uninstall < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/foxx'

        param :mount, :required
        param :teardown

        code 204, :success
      end
    end
  end
end
