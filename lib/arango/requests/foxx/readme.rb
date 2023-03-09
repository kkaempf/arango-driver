module Arango
  module Requests
    module Foxx
      class Readme < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/foxx/readme'

        param :mount

        code 200, :success
        code 204, "Readme not found!"
      end
    end
  end
end
