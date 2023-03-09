module Arango
  module Requests
    module Foxx
      class ReplaceDependencies < Arango::Request
        self.request_method = :put

        self.uri_template = '{/dbcontext}/_api/foxx/dependencies'

        param :mount, :required

        body_any

        code 200, :success
      end
    end
  end
end
