module Arango
  module Requests
    module Backup
      class Upload < Arango::Request
        self.request_method = :post

        self.uri_template = "/_admin/backup/upload"

        body :abort
        body :config
        body :id
        body :remote_repository
        body :upload_id

        code 200, :success
        code 202, :success
        code 400, "Bad paramaters given!"
        code 401, "Authentication to remote repository failed!"
        code 404, "Backup or ppload with given identifier could not be found!"
      end
    end
  end
end
