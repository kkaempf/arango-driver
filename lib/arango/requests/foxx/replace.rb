module Arango
  module Requests
    module Foxx
      class Replace < Arango::Request
        self.request_method = :put

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
