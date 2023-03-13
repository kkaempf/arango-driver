module Arango
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_admin/log
      class Log < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/log"

        param :level
        param :offset
        param :search
        param :size
        param :sort
        param :start
        param :upto

        code 200, :success
        code 400, "Invalid values for level or upto!"
        code 500, "Server out of memory!"
      end
    end
  end
end
