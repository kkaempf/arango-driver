module Arango
  module Requests
    # Graph Requests
    module Graph
      # API: GET {/dbcontext}/_api/gharial/{graph}/vertex
      class ListVertexCollections < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/vertex'

        code 200, :success
        code 404, "Graph could not be found!"
      end
    end
  end
end
