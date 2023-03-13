module Arango
  module Requests
    # Graph Requests
    module Graph
      # API: POST {/dbcontext}/_api/gharial/{graph}/vertex
      class AddVertexCollections < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/vertex'

        body :collection, :required
        
        code 200, :success
        code 404, "Graph could not be found!"
      end
    end
  end
end
