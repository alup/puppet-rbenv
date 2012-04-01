require 'rake'

begin
  require 'rspec/core/rake_task'
  require 'puppet-lint/tasks/puppet-lint'
rescue LoadError
  require 'rubygems'
  retry
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

task :test => :spec

task :default => :test
