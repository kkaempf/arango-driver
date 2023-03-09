module Arango
  module Requests
    module Graph
      class ListEdgeDefinitions < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/edge'

        code 200, :success
        code 404, "Graph could not be found!"
      end
    end
  end
end
