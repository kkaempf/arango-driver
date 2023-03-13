module Arango
  module Requests
    # Graph Requests
    module Graph
      # API: DELETE {/dbcontext}/_api/gharial/{graph}/edge/{definition}#definition
      class Remove
        EdgeDefinition < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/gharial/{graph}/edge/{definition}#definition'

        body :collection
        body :from
        body :to

        code 201, :success
        code 202, :success
        code 400, "Definition could be added because it is ill-formed or used in another graph with a different signature!"
        code 403, "Permission denied!"
        code 404, "Graph could not be found!"
      end
    end
  end
end
