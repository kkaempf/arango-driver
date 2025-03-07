module Arango
  # Arango Requests
  module Requests
    # Transaction Requests
    module Transaction
      # API: DELETE {/dbcontext}/_api/transaction/{id}
      class Delete < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/transaction/{id}'

        code 200, :success
        code 400, "Transaction cannot be aborted!"
        code 404, "Transaction unknown!"
        code 409, "Transaction already committed!"
      end
    end
  end
end
