module Arango
  module Requests
    module Graph
      class AddVertexCollections < Arango::Request
        request_method :post

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/vertex'

        body :collection, :required
        
        code 200, :success
        code 404, "Graph could not be found!"
      end
    end
  end
end
