module Arango
  module Requests
    # Foxx Requests
    module Foxx
      # API: GET {/dbcontext}/_api/foxx/readme
      class Readme < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/foxx/readme'

        param :mount

        code 200, :success
        code 204, "Readme not found!"
      end
    end
  end
end
