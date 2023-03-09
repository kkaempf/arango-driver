module Arango
  module Requests
    module Graph
      class RemoveVertexCollections < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/vertex/{collection}'

        param :drop_collection

        code 200, :success
        code 202, :success
        code 400, "Vertex collection still used in an edge definition!"
        code 403, "Permission denied!"
        code 404, "Graph could not be found!"
      end
    end
  end
end
