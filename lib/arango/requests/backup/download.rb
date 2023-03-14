module Arango
  # Arango Requests
  module Requests
    # Backup Requests
    module Backup
      # API: POST /_admin/backup/download
      class Download < Arango::Request
        self.request_method = :post

        self.uri_template = "/_admin/backup/download"

        body :abort
        body :config
        body :download_id
        body :id
        body :remote_repository

        code 200, :success
        code 202, :success
        code 400, "Bad paramaters given!"
        code 401, "Authentication to remote repository failed!"
        code 404, "Backup with given identifier could not be found!"
      end
    end
  end
end
