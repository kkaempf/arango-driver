module Arango
  module Requests
    # Foxx Requests
    module Foxx
      # API: GET {/dbcontext}/_api/foxx/swagger
      class Swagger < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/foxx/swagger'

        param :mount, :required

        # TODO
        # body is zip, js, json, form-data

        code 200, :success
      end
    end
  end
end
