module Arango
  # Arango Requests
  module Requests
    # Graph Requests
    module Graph
      # API: GET {/dbcontext}/_api/gharial
      class ListAll < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/gharial'

        code 200, :success
      end
    end
  end
end
