module Arango
  module Requests
    module Foxx
      class ListScripts < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/foxx/scripts'

        param :mount

        code 200, :success
      end
    end
  end
end
