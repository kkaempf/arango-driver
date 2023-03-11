module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Foxx
      class GetDependencies < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/foxx/dependencies'

        param :mount, :required

        code 200, :success
      end
    end
  end
end
