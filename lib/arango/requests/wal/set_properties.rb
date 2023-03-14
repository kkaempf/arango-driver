module Arango
  module Requests
    # Wal Requests
    module Wal
      # API: PUT /_admin/wal/properties
      class SetProperties < Arango::Request
        self.request_method = :put

        self.uri_template = "/_admin/wal/properties"

        body :allow_oversize_entries
        body :historic_logfiles
        body :logfile_size
        body :reserve_logfiles
        body :throttle_wait
        body :throttle_when_pending

        code 200, :success
        code 405, "Invalid HTTP method!"
      end
    end
  end
end
