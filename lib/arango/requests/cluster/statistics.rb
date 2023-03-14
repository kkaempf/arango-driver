module Arango
  module Requests
    # Cluster Requests
    module Cluster
      # API: GET /_admin/backup/statistics
      class Statistics < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/backup/statistics"

        # TODO db_server -> DBserver
        param :db_server

        code 201, :success
        code 400, "Bad paramaters or another error, see result!"
        code 403, "Error 403!"
      end
    end
  end
end
