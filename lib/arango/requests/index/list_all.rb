module Arango
  # Arango Requests
  module Requests
    # Index Requests
    module Index
      # API: GET {/dbcontext}/_api/index
      class ListAll < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/index'

        param :collection, :required
        
        code 200, :success
      end
    end
  end
end
