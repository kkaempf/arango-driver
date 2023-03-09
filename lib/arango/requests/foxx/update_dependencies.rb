module Arango
  module Requests
    module Foxx
      class UpdateDependencies < Arango::Request
        request_method :patch

        self.uri_template = '{/dbcontext}/_api/foxx/dependencies'

        param :mount, :required

        body_any

        code 200, :success
      end
    end
  end
end
