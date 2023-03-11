module Arango
  # Arango EdgeCollection
  module EdgeCollection
    STATES = %i[unknown new_born unloaded loaded being_unloaded deleted loading] # do not sort, index is used
    TYPES = %i[unknown unknown document edge] # do not sort, index is used

    # Arango EdgeCollection Mixin
    module Mixin
      #@!visibility private
      def self.included(base)
      #@!visibility public
        base.extend(Arango::EdgeCollection::ClassMethods)
        base.include(Arango::EdgeCollection::InstanceMethods)
        base.include(Arango::EdgeCollection::Edges)
      end
    end
  end
end
