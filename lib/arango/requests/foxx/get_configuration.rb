module Arango
  module Requests
    module Foxx
      class GetConfiguration < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/foxx/configuration'

        param :mount, :required

        code 200, :success
      end
    end
  end
end
