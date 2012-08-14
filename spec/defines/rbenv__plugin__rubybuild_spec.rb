require 'spec_helper'

describe 'rbenv::plugin::rubybuild', :type => :define do
  let(:user)      { 'tester' }
  let(:title)     { "rbenv::plugin::ruby-build #{user}" }
  let(:params)    { {:user => user} }

  it {
    should contain_rbenv__plugin("rbenv::plugin::rubybuild::#{user}").with(
      :plugin_name => 'ruby-build',
      :source      => 'git://github.com/sstephenson/ruby-build.git',
      :user        => user
    )
  }
end