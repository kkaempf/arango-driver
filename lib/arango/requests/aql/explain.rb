module Arango
  module Requests
    module AQL
      class Explain < Arango::Request
        request_method :post

        uri_template "/_api/explain"

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
