module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Graph
      class GetVertex < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/vertex/{collection}/{vertex}'

        header 'if-match'
        header 'if-none-match'

        param :rev

        code 200, :success
        code 304, "Edge has same revision!"
        code 403, "Permission denied!"
        code 404, "Graph or collection or edge could not be found!"
        code 412, "Revision mismatch!"
      end
    end
  end
end
