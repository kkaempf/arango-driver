module Arango
  module Requests
    # Transaction Requests
    module Transaction
      # API: GET {/dbcontext}/_api/transaction/{id}
      class Status < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/transaction/{id}'

        code 200, :success
        code 400, "Transaction identifier missing or malformed!"
        code 404, "Transaction unknown!"
      end
    end
  end
end
