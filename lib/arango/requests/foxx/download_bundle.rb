module Arango
  # Arango Requests
  module Requests
    # Foxx Requests
    module Foxx
      # API: POST {/dbcontext}/_api/foxx/download
      class DownloadBundle < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/foxx/download'

        param :mount

        code 200, :success
        code 400, "Mount path unknown!"
      end
    end
  end
end
