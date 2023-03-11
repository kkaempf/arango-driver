module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Graph
      class CreateEdge < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/edge/{collection}'

        param :return_new
        param :wait_for_sync

        body_any

        code 201, :success
        code 202, :success
        code 400, "Edge is invalid or _from or _to are missing!"
        code 403, "Permission denied!"
        code 404, "Graph could not be found!"
      end
    end
  end
end
