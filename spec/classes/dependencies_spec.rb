require 'spec_helper'

describe 'rbenv::dependencies' do
  let(:title) { 'rbenv::dependencies' }

  context 'Ubuntu' do
    let(:facts) { { :operatingsystem => 'Ubuntu' } }
    it { should include_class('rbenv::dependencies::ubuntu') }
  end

  context 'Debian' do
    let(:facts) { { :operatingsystem => 'Debian' } }
    it { should include_class('rbenv::dependencies::ubuntu') }
  end

  context 'CentOS' do
    let(:facts) { { :operatingsystem => 'CentOS' } }
    it { should include_class('rbenv::dependencies::centos') }
  end
end
