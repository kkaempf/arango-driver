module Arango
  module Requests
    module Transaction
      class Delete < Arango::Request
        request_method :delete

        self.uri_template = '{/dbcontext}/_api/transaction/{id}'

        code 200, :success
        code 400, "Transaction cannot be aborted!"
        code 404, "Transaction unknown!"
        code 409, "Transaction already committed!"
      end
    end
  end
end
