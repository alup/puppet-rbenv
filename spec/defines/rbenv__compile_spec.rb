require 'spec_helper'

describe 'rbenv::compile', :type => :define do
  let(:user)         { 'tester' }
  let(:ruby_version) { '1.9.3-p125' }
  let(:title)        { "rbenv::compile::#{user}::#{ruby_version}" }
  let(:dot_rbenv)    { "/home/#{user}/.rbenv" }
  let(:params)       { {:user => user, :ruby => ruby_version, :global => true} }

  it "installs ruby of the chosen version" do
    should contain_exec("rbenv::compile #{user} #{ruby_version}").
      with_command("rbenv install #{ruby_version} && touch #{dot_rbenv}/.rehash")
  end

  it "issues a rehash command" do
    should contain_exec("rbenv::rehash #{user} #{ruby_version}").
      with_command("rbenv rehash && rm -f #{dot_rbenv}/.rehash")
  end

  it "sets the global ruby version for the specific user" do
    should contain_file("rbenv::global #{user}").
      with_content("#{ruby_version}\n").
      with_require("Exec[rbenv::compile #{user} #{ruby_version}]")
  end

  it "installs ruby-build plugin from official repository" do
    should contain_rbenv__plugin__rubybuild("rbenv::rubybuild::#{user}")
  end

  it "installs bundler" do
    should contain_rbenv__gem("rbenv::bundler #{user} #{ruby_version}").
      with_ensure('present')
  end
end
