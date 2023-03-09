module Arango
  module Requests
    module Foxx
      class UpdateConfiguration < Arango::Request
        request_method :patch

        self.uri_template = '{/dbcontext}/_api/foxx/configuration'

        param :mount, :required

        body_any
        
        code 200, :success
      end
    end
  end
end
