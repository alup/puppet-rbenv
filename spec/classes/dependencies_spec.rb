require 'spec_helper'

describe 'rbenv::dependencies' do
  let(:title) { 'rbenv::dependencies' }

  context 'Ubuntu' do
    let(:facts) { {:osfamily => 'debian'} }
    it { should include_class('rbenv::dependencies::ubuntu') }
  end

  context 'RedHat' do
    let(:facts) { {:osfamily => 'redhat'} }
    it { should include_class('rbenv::dependencies::centos') }
  end

  context 'Suse' do
    let(:facts) { {:osfamily => 'suse'} }
    it { should include_class('rbenv::dependencies::suse') }
  end
end
