require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'

task :test => :spec

task :default => :test

desc "Update AUTHORS file"
task :authors do
  sh "git shortlog -s | awk '{ print $2 \" \" $3 }' > AUTHORS"
end
