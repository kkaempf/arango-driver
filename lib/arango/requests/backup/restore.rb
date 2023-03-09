module Arango
  module Requests
    module Backup
      class Restore < Arango::Request
        request_method :post

        self.uri_template = "/_admin/backup/restore"

        body :id, :required

        code 200, :success
        code 400, "Bad paramaters given!"
      end
    end
  end
end
