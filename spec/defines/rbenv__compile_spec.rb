require 'spec_helper'

describe 'rbenv::compile', :type => :define do
  let(:title) { 'rbenv::compile::tester::1.9.3-p125' }
  let(:params) { { :user => 'tester', :ruby_version => '1.9.3-p125' } }

  it "installs ruby of the chosen version" do
    should contain_exec("install ruby #{params[:ruby_version]}").
      with_command("rbenv-install #{params[:ruby_version]}")
  end

  it "issues a rehash command" do
    should contain_exec("rehash-rbenv").
      with_command("rbenv rehash")
  end

  it "sets the global ruby version for the specific user" do
    should contain_exec("set-ruby_version").
      with_command("rbenv global #{params[:ruby_version]}")
  end
end
