module Arango
  # Arango Requests
  module Requests
    # Index Requests
    module Index
      # API: DELETE {/dbcontext}/_api/index/{collection}/{id}
      class Delete < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/index/{collection}/{id}'

        code 200, :success
        code 404, "Index unknown!"
      end
    end
  end
end
