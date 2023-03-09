module Arango
  module Requests
    module Graph
      class CreateVertex < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/vertex/{collection}'

        param :return_new
        param :wait_for_sync

        body_any

        code 201, :success
        code 202, :success
        code 403, "Permission denied!"
        code 404, "Graph could not be found!"
      end
    end
  end
end
