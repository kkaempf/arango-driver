module Arango
  module Requests
    # Wal Requests
    module Wal
      # API: GET /_admin/wal/transactions
      class Transactions < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/wal/transactions"

        code 200, :success
        code 405, "Invalid HTTP method!"
        code 501, :success
      end
    end
  end
end
