require_relative 'lib/arango/version.rb'

Gem::Specification.new do |s|
  s.name        = 'arangodb-driver'
  s.version     = Arango::VERSION
  s.authors     = ['Stefano Martin', 'Jan Biedermann', 'Klaus Kämpf']
  s.email       = ['kkaempf@suse.de']
  s.homepage    = 'https://github.com/kkaempf/arangodb-driver'
  s.license     = 'MIT'
  s.summary     = 'A simple ruby client for ArangoDB >= 3.10'
  s.description = "Ruby driver for ArangoDB's HTTP API\narangodb-driver is a drop-in replacement for the (unmaintained) arango-driver"
  s.require_paths = ['lib']
  s.files         = `git ls-files -- {lib,LICENSE,README.md}`.split("\n") + %w[arango_opal.js]
  s.add_dependency 'activesupport', '~> 7.0'
  s.add_dependency 'addressable', '~> 2.8'
  s.add_dependency 'escape_utils', '~> 1.3'
  s.add_dependency 'isomorfeus-redux', '~> 4.1'
  s.add_dependency 'oj', '~> 3.13'
  s.add_dependency 'opal', '~> 1.2'
  s.add_dependency 'typhoeus', '~> 1.4'
  s.add_dependency 'method_source', '~> 1.0'
  s.add_dependency 'parser', '~> 3.1'
  s.add_dependency 'unparser', '~> 0.6'
  s.add_dependency 'zeitwerk', '~> 2.6'
  s.add_development_dependency 'benchmark-ips', '~> 2.10'
  s.add_development_dependency 'opal-webpack-loader', '~> 0.13'
  s.add_development_dependency 'rake', '~> 13'
  s.add_development_dependency 'rspec', '~> 3.11'
  s.add_development_dependency 'simplecov', '~> 0.21'
  s.add_development_dependency 'yard', '~> 0.9'
end
