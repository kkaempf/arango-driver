module Arango
  # Arango Requests
  module Requests
    # Foxx Requests
    module Foxx
      # API: POST {/dbcontext}/_api/foxx/commit
      class Commit < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/foxx/commit'

        param :replace

        code 204, :success
      end
    end
  end
end
