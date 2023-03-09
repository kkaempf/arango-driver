module Arango
  module Requests
    module Graph
      class UpdateVertex < Arango::Request
        request_method :patch

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/vertex/{collection}/{vertex}'

        header 'if-match'

        param :keep_null
        param :return_new
        param :return_old
        param :wait_for_sync

        body_any

        code 200, :success
        code 202, :success
        code 403, "Permission denied!"
        code 404, "Graph or collection or edge could not be found!"
        code 412, "Revision mismatch!"
      end
    end
  end
end
