module Arango
  # Arango Requests
  module Requests
    # Graph Requests
    module Graph
      # API: DELETE {/dbcontext}/_api/gharial/{graph}
      class Delete < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}'

        param :drop_collections

        code 201, :success
        code 202, :success
        code 403, "Permission denied!"
        code 404, "Graph could not be found!"
      end
    end
  end
end
