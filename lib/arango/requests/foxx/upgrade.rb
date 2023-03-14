module Arango
  module Requests
    # Foxx Requests
    module Foxx
      # API: PATCH {/dbcontext}/_api/foxx/service
      class Upgrade < Arango::Request
        self.request_method = :patch

        self.uri_template = '{/dbcontext}/_api/foxx/service'

        param :mount, :required
        param :force
        param :legacy
        param :setup
        param :teardown

        # TODO
        # body is zip, js, json, form-data

        code 204, :success
      end
    end
  end
end
