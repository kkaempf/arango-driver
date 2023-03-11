module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Foxx
      class DisableDevelopmentMode < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/foxx/development'

        param :mount, :required

        code 200, :success
      end
    end
  end
end
