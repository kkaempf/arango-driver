module Arango
  module Requests
    module Graph
      class Get < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}'

        param :drop_collections

        code 200, :success
        code 404, "Graph could not be found!"
      end
    end
  end
end
