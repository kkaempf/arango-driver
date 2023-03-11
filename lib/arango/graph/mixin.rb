module Arango
  # Arango Graph
  module Graph
    # Arango Graph Mixin
    module Mixin
      #@!visibility private
      def self.included(base)
      #@!visibility public
        base.extend(Arango::Graph::ClassMethods)
        base.include(Arango::Graph::InstanceMethods)
        # base.include(Arango::Graph::Definition)
        # base.include(Arango::Graph::EdgeCollections)
        # base.include(Arango::Graph::VertexCollections)
      end
    end
  end
end
