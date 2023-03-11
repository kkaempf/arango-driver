module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Foxx
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
