module Arango
  module Requests
    module Graph
      class Delete < Arango::Request
        request_method :delete

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}'

        param :drop_collections

        code 201, :success
        code 202, :success
        code 403, "Permission denied!"
        code 404, "Graph could not be found!"
      end
    end
  end
end
