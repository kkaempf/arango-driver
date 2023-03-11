module Arango
  # Arango Database
  class Database
    # Arango Database AQLFunctions
    module AQLFunctions

      def list_aql_functions(namespace: nil)
        params = nil
        params = { namespace: namespace } unless namespace.nil?
        result = Arango::Requests::AQL::ListFunctions(server: @server, params: params)
        result.map { |r| Arango::Result.new(r) }
      end

      def create_aql_function(name, code: nil, is_deterministic: nil, &block)
        if block_given?
          source_block = Parser::CurrentRuby.parse(block.source).children.last
          source_block = source_block.children.last if source_block.type == :block
          source_code = Unparser.unparse(source_block)
          ruby_header = <<~RUBY
          args = `original_arguments`
          RUBY
          compiled_ruby= Opal.compile(ruby_header + source_code, parse_comments: false)
          if compiled_ruby.start_with?('/*')
            start_of_code = compiled_ruby.index('*/') + 3
            compiled_ruby = compiled_ruby[start_of_code..-1]
          end
          code = <<~JAVASCRIPT
          function() {
            "use strict";
            require('opal');
            var original_arguments = Array.prototype.slice.call(arguments);
            for (var i=0; i<original_arguments.length; i++) {
              if (typeof original_arguments[i] === "object" && !(original_arguments[i] instanceof Array)) {
                original_arguments[i] = Opal.Hash.$new(original_arguments[i]);
              }
            }
            var result = #{compiled_ruby}
            if (typeof result['$to_n'] === "function") { result = result['$to_n'](); }
            return result;
          }
          JAVASCRIPT
        end
        body = { name: name, code: code, isDeterministic: is_deterministic }
        Arango::Requests::AQL::CreateFunction.execute(server: @server, body: body)
        true
      end

      def drop_aql_function(name, namespace: nil)
        params = nil
        params = { namespace: namespace } unless group.nil?
        args = { name: name }
        Arango::Requests::AQL::CreateFunction.execute(server: @server, args: args, params: params)
        true
      end
    end
  end
end
