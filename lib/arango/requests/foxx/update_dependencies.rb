module Arango
  module Requests
    # Foxx Requests
    module Foxx
      # API: PATCH {/dbcontext}/_api/foxx/dependencies
      class UpdateDependencies < Arango::Request
        self.request_method = :patch

        self.uri_template = '{/dbcontext}/_api/foxx/dependencies'

        param :mount, :required

        body_any

        code 200, :success
      end
    end
  end
end
