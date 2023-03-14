module Arango
  # Arango Requests
  module Requests
    # Foxx Requests
    module Foxx
      # API: GET {/dbcontext}/_api/foxx/service
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
