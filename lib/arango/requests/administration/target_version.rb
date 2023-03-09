module Arango
  module Requests
    module Administration
      class TargetVersion < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/database/target-version"

        code 200, :success
      end
    end
  end
end
