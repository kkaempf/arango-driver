module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Foxx
      class EnableDevelopmentMode < Arango::Request
        self.request_method = :enable

        self.uri_template = '{/dbcontext}/_api/foxx/development'

        param :mount, :required

        code 200, :success
      end
    end
  end
end
