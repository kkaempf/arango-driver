module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Foxx
      class Description < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/foxx/service'

        param :mount, :required

        code 200, :success
        code 400, "Mount path unknown!"
      end
    end
  end
end
