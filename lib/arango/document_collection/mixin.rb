module Arango
  # Arango DocumentCollection
  module DocumentCollection
    STATES = %i[unknown new_born unloaded loaded being_unloaded deleted loading] # do not sort, index is used
    TYPES = %i[unknown unknown document edge] # do not sort, index is used

    # Arango DocumentCollection Mixin
    module Mixin
      #@!visibility private
      def self.included(base)
      #@!visibility public
        base.extend(Arango::DocumentCollection::ClassMethods)
        base.include(Arango::DocumentCollection::InstanceMethods)
        base.include(Arango::DocumentCollection::Documents)

        include Arango::Helper::Satisfaction

        include Arango::DocumentCollection::Documents
        include Arango::DocumentCollection::Indexes
      end
    end
  end
end
