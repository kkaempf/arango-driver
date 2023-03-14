module Arango
  # Arango Requests
  module Requests
    # Foxx Requests
    module Foxx
      # API: POST {/dbcontext}/_api/foxx/service
      class Install < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/foxx/service'

        param :development
        param :legacy
        param :mount, :required
        param :setup

        # TODO
        # body is zip, js, json, form-data

        code 201, :success
      end
    end
  end
end
