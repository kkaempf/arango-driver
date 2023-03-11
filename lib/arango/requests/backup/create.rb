module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Backup
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
