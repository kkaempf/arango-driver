require 'oj'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new :rspec

task :default => [:rspec]

task :build_package do
  system('gem build arango-driver.gemspec')
end

task :doc do
  system('yard')
end
