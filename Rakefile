require 'oj'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new :rspec

task :default => [:rspec, :print_coverage]

task :build_package do
  system('gem build arango-driver.gemspec')
end

task :print_coverage do
  data = Oj.load(File.read('coverage/.last_run.json'), mode: :strict)
  puts "Coverage: #{data['result']['covered_percent']}%"
end
