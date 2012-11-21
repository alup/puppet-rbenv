require 'spec_helper'

describe 'rbenv::install', :type => :define do
  let(:user)   { 'tester' }
  let(:title)  { "rbenv::install::#{user}" }
  let(:params) { {:user => user} }

  context 'install rbenv' do
    it "clones rbenv from the official repository" do
      should contain_exec("rbenv::checkout #{user}").
        with_command("git clone git://github.com/sstephenson/rbenv.git /home/#{user}/.rbenv")
    end

    it "appends in a rc file, a command to include .rbenv/bin folder in PATH env variable" do
      should contain_exec("rbenv::shrc #{user}").
        with_command("echo 'source /home/#{user}/.rbenvrc' >> /home/#{user}/.profile")
    end

    it "creates a cache folder" do
      should contain_file("rbenv::cache-dir #{user}").
        with(:ensure => "directory", :path => "/home/#{user}/.rbenv/cache")
    end
  end
end
