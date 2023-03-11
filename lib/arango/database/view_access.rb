module Arango
  # Arango Database
  class Database
    # Arango Database ViewAccess
    module ViewAccess
      def create_search_view
        # TODO
      end

      def search_view(name)
        # TODO Returns a ArangoSearchView instance for the given view name
      end

      def list_views
        # TODO Fetches all views from the database and returns an array of view descriptions.
      end

      # verified, in js api
      def views
        result = request("GET", "_api/view", key: :result)
        return result if return_directly?(result)
        result.map do |view|
          Arango::View.new(database: self, id: view[:id], name: view[:name], type: view[:type])
        end
      end

      # not found
      def view(name)
        Arango::View.new(database: self, name: name)
      end

      def create_view

      end
    end
  end
end
