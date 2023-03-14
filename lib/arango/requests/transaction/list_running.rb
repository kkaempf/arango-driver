module Arango
  module Requests
    # Transaction Requests
    module Transaction
      # API: GET {/dbcontext}/_api/transaction
      class ListRunning < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/transaction'

        code 200, :success
      end
    end
  end
end
