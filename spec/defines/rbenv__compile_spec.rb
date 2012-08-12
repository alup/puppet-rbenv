require 'spec_helper'

describe 'rbenv::compile', :type => :define do
  let(:user)         { 'tester' }
  let(:ruby_version) { '1.9.3-p125' }
  let(:title)        { "rbenv::compile::#{user}::#{ruby_version}" }
  let(:params)       { {:user => user, :ruby => ruby_version, :set_default => true } }

  it "installs ruby of the chosen version" do
    # p subject.resource('Exec', 'rbenv::compile tester 1.9.3-p125')
    should contain_exec("rbenv::compile #{user} #{ruby_version}").
      with_command("rbenv install #{ruby_version}; touch /home/#{user}/.rbenv/.rehash")
  end

  it "issues a rehash command" do
    should contain_exec("rbenv::rehash #{user}").
      with_command("rbenv rehash; rm -f /home/#{user}/.rbenv/.rehash")
  end

  it "sets the global ruby version for the specific user" do
    should contain_file("rbenv::global #{user}").
      with_content("#{ruby_version}\n")
  end
end
