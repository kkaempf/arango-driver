require "json"
require "parser"
require "unparser"
require "method_source"
require "escape_utils"
require "active_support/core_ext/string"

if RUBY_ENGINE == 'opal'
  raise "Opal is unsupported"
elsif RUBY_ENGINE == 'ruby'
  require "oj"
  require "typhoeus"
elsif RUBY_ENGINE == 'jruby'
  raise "JRuby is unsupported"
end

require 'zeitwerk'
require 'arango'

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)

#loader.log!
# override Zeitwerk's AQL -> Aql mapping
loader.inflector.inflect(
  "aql" => "AQL",
  "aql_functions" => "AQLFunctions",
  "aql_queries" => "AQLQueries",
  "aql_query_cache" => "AQLQueryCache",
  "http_route" => "HTTPRoute",
  "error_db" => "ErrorDB"
)
loader.ignore(__FILE__)
loader.setup

if RUBY_ENGINE == 'opal'
  # TODO check if running in FOXX or node
  # if in node
  # Arango.driver = Arango::Driver::Node
  # if in FOXX
  # no driver needed?
elsif RUBY_ENGINE == 'ruby'
  Arango.driver = Arango::Driver::Typhoeus
elsif RUBY_ENGINE == 'jruby'
  # Arango.driver = Arango::Driver::JRuby
end
