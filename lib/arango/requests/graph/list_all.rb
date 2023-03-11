module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Graph
      class ListAll < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/gharial'

        code 200, :success
      end
    end
  end
end
