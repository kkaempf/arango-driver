module Arango
  module Requests
    module Transaction
      class Execute < Arango::Request
        request_method :post

        self.uri_template = '{/dbcontext}/_api/transaction'

        body :action
        body :allow_implicit
        body :collections
        body :lock_timeout
        body :max_transaction_size
        body :params
        body :wait_for_sync

        code 200, :success
        code 400, "Transaction specification missing or malformed!"
        code 404, "Transaction specification contains unknown collection!"
        code 500, "Exception by user thrown!"
      end
    end
  end
end
