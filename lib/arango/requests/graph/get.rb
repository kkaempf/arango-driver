module Arango
  # Arango Requests
  module Requests
    # Graph Requests
    module Graph
      # API: GET {/dbcontext}/_api/gharial/{graph}
      class Get < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}'

        param :drop_collections

        code 200, :success
        code 404, "Graph could not be found!"
      end
    end
  end
end
