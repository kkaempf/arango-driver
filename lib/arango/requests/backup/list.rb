module Arango
  # Arango Requests
  module Requests
    # Backup Requests
    module Backup
      # API: POST /_admin/backup/list
      class List < Arango::Request
        self.request_method = :post

        self.uri_template = "/_admin/backup/list"

        body :id

        code 200, :success
        code 400, "Bad paramaters given!"
        code 404, "Backup with given identifier could not be found!"
        code 405, "Request method not allowed!"
      end
    end
  end
end
