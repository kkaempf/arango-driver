module Arango
  module Requests
    module Graph
      class DeleteEdge < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/edge/{collection}/{edge}'

        header 'if-match'

        param :return_old
        param :wait_for_sync

        code 200, :success
        code 202, :success
        code 403, "Permission denied!"
        code 404, "Graph or collection or edge could not be found!"
        code 412, "Revision mismatch!"
      end
    end
  end
end
