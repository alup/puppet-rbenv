require 'rake'
require 'rspec/core/rake_task'

# Add task for puppet-lint
require 'puppet-lint/tasks/puppet-lint'

# Add task for testing with rspec
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

task :default => :spec
