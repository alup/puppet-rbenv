require 'spec_helper'

describe 'rbenv::install', :type => :define do
  let(:user)   { 'tester' }
  let(:home)   { "/home/#{user}" }
  let(:title)  { "rbenv::install::#{user}" }
  let(:params) { {:user => user} }

  context 'install rbenv' do
    it "clones rbenv from the official repository" do
      should contain_exec("rbenv::checkout #{user}").
        with_command("git clone git://github.com/sstephenson/rbenv.git /home/#{user}/.rbenv")
    end

    it "appends in a rc file, a command to include .rbenv/bin folder in PATH env variable" do
      should contain_exec("rbenv::shrc #{user}").
        with_command("echo 'source #{home}/.rbenvrc # Added by Puppet-Rbenv.' | cat - #{home}/.profile > #{home}/.profile.tmp && mv #{home}/.profile.tmp #{home}/.profile").
        with_unless("head -1 #{home}/.profile | grep -q #{home}/.rbenvrc")
    end
  end
end
