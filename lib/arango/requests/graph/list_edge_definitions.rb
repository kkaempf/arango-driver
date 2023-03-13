module Arango
  module Requests
    # Graph Requests
    module Graph
      # API: GET {/dbcontext}/_api/gharial/{graph}/edge
      class ListEdgeDefinitions < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/edge'

        code 200, :success
        code 404, "Graph could not be found!"
      end
    end
  end
end
