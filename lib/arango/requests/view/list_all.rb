module Arango
  module Requests
    # View Requests
    module View
      # API: GET {/dbcontext}/_api/view
      class ListAll < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/view'

        code 200, :success
      end
    end
  end
end
