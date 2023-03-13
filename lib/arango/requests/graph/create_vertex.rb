module Arango
  # Arango Requests
  module Requests
    # Graph Requests
    module Graph
      # API: GET {/dbcontext}/_api/gharial/{graph}/vertex/{collection}
      class CreateVertex < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/vertex/{collection}'

        param :return_new
        param :wait_for_sync

        body_any

        code 201, :success
        code 202, :success
        code 403, "Permission denied!"
        code 404, "Graph could not be found!"
      end
    end
  end
end
