module Arango
  module Requests
    # Backup Requests
    module Backup
      # API: POST /_admin/backup/restore
      class Restore < Arango::Request
        self.request_method = :post

        self.uri_template = "/_admin/backup/restore"

        body :id, :required

        code 200, :success
        code 400, "Bad paramaters given!"
      end
    end
  end
end
