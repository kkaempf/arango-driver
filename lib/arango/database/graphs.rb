module Arango
  # Arango Database
  class Database
    # Arango Database Graphs
    module Graphs
      def all_graphs
        Arango::Graph::Base.all(database: self)
      end

      # TODO issmart, edgedefinitions, waitforsync, options
      def create_graph(name:, edge_definitions: [], is_smart: nil)
        Arango::Graph::Base.new(name: name, edge_definitions: edge_definitions, is_smart: is_smart, database: self).create
      end

      def get_graph(name:)
        Arango::Graph::Base.get(name: name, database: self)
      end

      def new_graph(name:, edge_definitions: [], is_smart: nil)
        Arango::Graph::Base.new(name: name, edge_definitions: edge_definitions, is_smart: is_smart, database: self)
      end

      def list_graphs
        Arango::Graph::Base.list(database: self)
      end

      def delete_graph(name:)
        Arango::Graph::Base.delete(name: name, database: self)
      end

      def graph_exists?(name:)
        Arango::Graph::Base.exists?(name: name, database: self)
      end
    end
  end
end
