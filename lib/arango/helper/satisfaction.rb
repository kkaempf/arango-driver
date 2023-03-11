module Arango
  # Arango Helper
  module Helper
    # Arango Helper Satisfaction
    module Satisfaction
      def satisfy_class?(object, *classes)
        return true if classes.include?(object.class)
        name ||= object.object_id.to_s
        raise Arango::Error.new err: :wrong_class, data: { wrong_value: name, wrong_class: object.class.to_s, expected_class: classes.to_s }
      end

      def satisfy_class_or_string?(object, *classes)
        return true if object.class == String
        satisfy_class?(object, *classes)
      end

      def satisfy_module?(object, *modules)
        object_ancestors = object.class.ancestors
        object_incl_modules = object.class.included_modules
        result = (object_ancestors | object_incl_modules) & modules
        return true if result.size > 0
        name ||= object.object_id.to_s
        raise Arango::Error.new err: :wrong_module, data: { wrong_value: name, wrong_module: object.class.to_s, expected_class: modules.to_s }
      end

      def satisfy_module_or_string?(object, *modules)
        return true if object.class == String
        satisfy_module?(object, *modules)
      end

      def satisfy_module_or_nil?(object, *modules)
        return true if object.nil?
        satisfy_module?(object, *modules)
      end

      def satisfy_category?(object, list)
        return true if list.include?(object)
        name = object.object_id.to_s
        raise Arango::Error.new err: :wrong_element, data: { wrong_attribute: name, wrong_value: object, list: list }
      end

      def warning_deprecated(warning, name)
        puts "ARANGORB WARNING: #{name} function is deprecated" if warning
      end
    end
  end
end
