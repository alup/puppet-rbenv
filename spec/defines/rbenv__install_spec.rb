require 'spec_helper'

describe 'rbenv::install', :type => :define do
  let(:title) { 'rbenv::install::tester' }
  let(:params) { { :user => 'tester' } }

  context 'install rbenv' do
    it "clones rbenv from the official repository" do
      should contain_exec("rbenv::install::#{params[:user]}::checkout").
        with_command("git clone git://github.com/sstephenson/rbenv.git .rbenv")
    end

    it "appends in .bashrc, a command to include .rbenv/bin folder in PATH env variable" do
      should contain_exec("rbenv::install::#{params[:user]}::add_path_to_bashrc").
        with_command('echo "export PATH=/home/tester/.rbenv/bin:$PATH" >> .bashrc')
    end

    it "appends in .bashrc, a command to initialiaze rbenv in each bash session" do
      should contain_exec("rbenv::install::#{params[:user]}::add_init_to_bashrc").
        with_command('echo "eval \"\$(rbenv init -)\"" >> .bashrc')
    end
  end


  context 'install ruby-build' do
    it "clones ruby-build" do
      should contain_exec("rbenv::install::#{params[:user]}::checkout_ruby_build").
        with_command("git clone git://github.com/sstephenson/ruby-build.git")
    end
  end

end
