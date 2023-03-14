module Arango
  # Arango Requests
  module Requests
    # Backup Requests
    module Backup
      # API: POST /_admin/backup/create
      class Create < Arango::Request
        self.request_method = :post

        self.uri_template = "/_admin/backup/create"

        body :allow_inconsistent
        body :force
        body :label
        body :timeout

        code 201, :success
        code 400, "Bad paramaters givenlt!"
        code 408, "Could not obtain global transaction lock within timeout!"
      end
    end
  end
end
