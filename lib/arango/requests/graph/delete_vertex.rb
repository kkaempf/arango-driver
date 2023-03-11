module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Graph
      class DeleteVertex < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/vertex/{collection}/{vertex}'

        header 'if-match'

        param :return_old
        param :wait_for_sync

        code 200, :success
        code 202, :success
        code 403, "Permission denied!"
        code 404, "Graph or collection or vertex could not be found!"
        code 412, "Revision mismatch!"
      end
    end
  end
end
