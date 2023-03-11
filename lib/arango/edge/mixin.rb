module Arango
  # Arango Edge
  module Edge
    # Arango Edge Mixin
    module Mixin
      #@!visibility private
      def self.included(base)
      #@!visibility public
        base.include(Arango::Helper::Satisfaction)
        base.extend(Arango::Edge::ClassMethods)
        base.include(Arango::Edge::InstanceMethods)
      end
    end
  end
end
