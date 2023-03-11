module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module AQL
      class Explain < Arango::Request
        self.request_method = :post

        self.uri_template = "/_api/explain"

        body :bind_vars
        body :query
        body :options do
          key :all_plans
          key :max_number_of_plans
          key :optimizer
        end

        code 200, :success
        code 400, "Malformed request or parse error!"
        code 404, "Non existing collection has been accessed!"
      end
    end
  end
end
