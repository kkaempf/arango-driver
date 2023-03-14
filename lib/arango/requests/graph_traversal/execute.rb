module Arango
  # Arango Requests
  module Requests
    # GraphTraversal Requests
    module GraphTraversal
      # API: POST {/dbcontext}/_api/traversal
      class Execute < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/traversal'

        body :direction
        body :edge_collection
        body :expander
        body :filter
        body :graph_name
        body :item_order
        body :init
        body :max_depth
        body :max_iterations
        body :order
        body :sort
        body :start_vertex
        body :strategy
        body :uniqueness
        body :visitor

        code 200, :success
        code 400, "Traversal specification missing or malformed!"
        code 404, "Edge collection or start vertex unknown!"
        code 500, "Error within traversal or more than max_iterations performed!"
      end
    end
  end
end
