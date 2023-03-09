module Arango
  module Requests
    module Foxx
      class DownloadBundle < Arango::Request
        request_method :post

        self.uri_template = '{/dbcontext}/_api/foxx/download'

        param :mount

        code 200, :success
        code 400, "Mount path unknown!"
      end
    end
  end
end
