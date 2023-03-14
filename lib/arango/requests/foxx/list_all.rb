module Arango
  # Arango Requests
  module Requests
    # Foxx Requests
    module Foxx
      # API: GET {/dbcontext}/_api/foxx
      class ListAll < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/foxx'

        param :exclude_system

        code 200, :success
      end
    end
  end
end
