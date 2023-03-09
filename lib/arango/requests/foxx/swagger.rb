module Arango
  module Requests
    module Foxx
      class Swagger < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/foxx/swagger'

        param :mount, :required

        # TODO
        # body is zip, js, json, form-data

        code 200, :success
      end
    end
  end
end
