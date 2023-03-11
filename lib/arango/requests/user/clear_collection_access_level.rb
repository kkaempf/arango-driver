module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module User
      class ClearCollectionAccessLevel < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/user/{user}/database/{database}/{collection}'

        code 202, :success
        code 400, "A error occurred!"
      end
    end
  end
end
