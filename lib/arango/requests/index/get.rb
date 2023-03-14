module Arango
  # Arango Requests
  module Requests
    # Index Requests
    module Index
      # API: GET {/dbcontext}/_api/index/{collection}/{id}
      class Get < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/index/{collection}/{id}'

        code 200, :success
        code 404, "Index unknown!"
      end
    end
  end
end
