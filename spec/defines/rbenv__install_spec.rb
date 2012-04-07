require 'spec_helper'

describe 'rbenv::install', :type => :define do
  let(:title) { 'rbenv::install::tester' }
  let(:params) { { :user => 'tester' } }

  context 'install rbenv' do
    it "clones rbenv from the official repository" do
      should contain_exec("checkout rbenv").
        with_command("git clone git://github.com/sstephenson/rbenv.git .rbenv")
    end

    it "appends in .bashrc, a command to include .rbenv/bin folder in PATH env variable" do
      should contain_exec("configure rbenv path").
        with_command('echo "export PATH=\$HOME/.rbenv/bin:\$PATH" >> .bashrc')
    end

    it "appends in .bashrc, a command to initialiaze rbenv in each bash session" do
      should contain_exec("configure rbenv init").
        with_command('echo "eval \"\$(rbenv init -)\"" >> .bashrc')
    end
  end


  context 'install ruby-build' do
    it "clones ruby-build" do
      should contain_exec("checkout ruby-build").
        with_command("git clone git://github.com/sstephenson/ruby-build.git")
    end

    it "runs installation shell script" do
      should contain_exec("install ruby-build").
        with_command("sh install.sh")
    end
  end

end
