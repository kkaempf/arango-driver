module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module View
      class Get < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/view/{name}'

        code 200, :success
        code 404, "View unknown!"
      end
    end
  end
end
