require 'spec_helper'

describe 'rbenv::plugin::rbenvvars', :type => :define do
  let(:user)      { 'tester' }
  let(:title)     { user }

  it {
    should contain_rbenv__plugin("rbenv::plugin::rbenvvars::#{user}").with(
      :plugin_name => 'rbenv-vars',
      :source      => 'git://github.com/sstephenson/rbenv-vars.git',
      :user        => user
    )
  }
end
