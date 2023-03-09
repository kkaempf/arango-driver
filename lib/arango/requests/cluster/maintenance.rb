module Arango
  module Requests
    module Cluster
      class Maintenance < Arango::Request
        self.request_method = :put

        self.uri_template = "/_admin/cluster/maintenance"

        # TODO
        # body_is_string

        code 200, :success
        code 400, "Bad paramaters given!"
        code 501, "Error 501!"
        code 504, "Error 504!"
      end
    end
  end
end
