module Arango
  # Arango Requests
  module Requests
    module Transaction
      class Begin < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/transaction/begin'

        body :allow_implicit
        body :collections
        body :lock_timeout
        body :max_transaction_size
        body :wait_for_sync

        code 201, :success
        code 400, "Transaction specification missing or malformed!"
        code 404, "Transaction specification contains unknown collection!"
      end
    end
  end
end
