module Arango
  # Arango Document
  module Document
    # Arango Document Mixin
    module Mixin
      #@!visibility private
      def self.included(base)
      #@!visibility public
        base.include(Arango::Helper::Satisfaction)
        base.extend(Arango::Document::ClassMethods)
        base.include(Arango::Document::InstanceMethods)
      end
    end
  end
end
