module Arango
  module Requests
    module Cluster
      class Statistics < Arango::Request
        request_method :get

        self.uri_template = "/_admin/backup/create"

        # TODO db_server -> DBserver
        param :db_server

        code 201, :success
        code 400, "Bad paramaters or another error, see result!"
        code 403, "Error 403!"
      end
    end
  end
end
