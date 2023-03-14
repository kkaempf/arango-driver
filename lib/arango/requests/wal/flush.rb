module Arango
  # Arango Requests
  module Requests
    # Wal Requests
    module Wal
      # API: PUT /_admin/wal/flush
      class Flush < Arango::Request
        self.request_method = :put

        self.uri_template = "/_admin/wal/flush"

        param :wait_for_collector
        param :wait_for_sync

        code 200, :success
        code 405, "Invalid HTTP method!"
      end
    end
  end
end
