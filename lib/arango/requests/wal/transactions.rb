module Arango
  module Requests
    module Wal
      class Transactions < Arango::Request
        request_method :get

        self.uri_template = "/_admin/wal/transactions"

        code 200, :success
        code 405, "Invalid HTTP method!"
        code 501, :success
      end
    end
  end
end
