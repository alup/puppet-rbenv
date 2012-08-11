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

desc "Update AUTHORS file"
task :authors do
  sh "git shortlog -s | awk '{ print $2 \" \" $3 }' > AUTHORS"
end
