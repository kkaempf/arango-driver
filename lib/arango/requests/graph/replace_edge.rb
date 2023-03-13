module Arango
  module Requests
    # Graph Requests
    module Graph
      # API: PUT {/dbcontext}/_api/gharial/{graph}/edge/{collection}/{edge}
      class ReplaceEdge < Arango::Request
        self.request_method = :put

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/edge/{collection}/{edge}'

        header 'if-match'

        param :keep_null
        param :return_new
        param :return_old
        param :wait_for_sync

        body :_from
        body :_to
        body_any

        code 201, :success
        code 202, :success
        code 403, "Permission denied!"
        code 404, "Graph or collection or edge could not be found!"
        code 412, "Revision mismatch!"
      end
    end
  end
end
