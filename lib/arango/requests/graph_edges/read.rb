module Arango
  module Requests
    module GraphEdges
      class Read < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/edges/{id}'

        param :direction
        param :vertex

        code 201, :success
        code 400, "Request contains invalid paramaters!"
        code 404, "Edge collection not found!"
      end
    end
  end
end
