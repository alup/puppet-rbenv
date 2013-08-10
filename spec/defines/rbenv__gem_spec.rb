require 'spec_helper'

describe 'rbenv::gem', :type => :define do
  # User must be unique to this spec so that our fixture doesn't break other specs.
  # User and version muct match what's in the Exec[rbenv::compile...] 
  # in spec/fixtures/manifests/site.pp so that the 'is this ruby installed' test
  # in the defined type will pass.
  let(:user)         { 'gem_tester' }
  let(:ruby_version) { '1.9.3-p125' }
  let(:title)        { 'somegem' }
  let(:gem_name)     { title }
  let(:rbenv)        { "/home/#{user}/.rbenv/versions/#{ruby_version}" }
  let(:_ensure)      { 'present' }
  let(:params)       { {:user => user, :ruby => ruby_version } }

  before do
  end

  describe 'when the ruby version has not been installed' do
    let(:ruby_version) { '0.0.0' } 
    it 'fails' do
      expect {
        should contain_class('foo')
      }.to raise_error(Puppet::Error, /Rbenv-Ruby #{ruby_version} for user #{user} not found in catalog/)
    end
  end

  shared_examples 'rbenvgem' do
    it { 
      should contain_rbenvgem("#{user}/#{ruby_version}/#{gem_name}/#{_ensure}").with(
        'ensure' => _ensure,
        'user' => params[:user],
        'gemname' => gem_name,
        'ruby' => params[:ruby],
        'rbenv' => rbenv
      ) 
    }
  end

  it_behaves_like "rbenvgem"

  describe "when there is an ensure param" do
    let(:params) { { :ensure => 'absent', :user => user, :ruby => ruby_version } }
    it_behaves_like "rbenvgem" do
      let(:_ensure) { params[:ensure] }
    end
  end

  describe "when there is a gem param" do
    let(:params) { { :gem => 'some-other-gem', :user => user, :ruby => ruby_version } }
    it_behaves_like "rbenvgem" do
      let(:gem_name) { params[:gem] }
    end
  end

  describe "when there is a home param" do
    let(:params) { { :home => '/usr/local/foo', :user => user, :ruby => ruby_version } }
    it_behaves_like "rbenvgem" do
      let(:rbenv) { "#{params[:home]}/.rbenv/versions/#{ruby_version}" }
    end
  end

  describe "when there is a root param" do
    let(:params) { { :root => '/usr/local/bar/.rbenv', :user => user, :ruby => ruby_version } }
    it_behaves_like "rbenvgem" do
      let(:rbenv) { "#{params[:root]}/versions/#{ruby_version}" }
    end
  end

  describe "when there is both a home and a root param the root takes precedence" do
    let(:params) { { :home => '/usr/local/foo', :root => '/usr/local/bar/.rbenv', :user => user, :ruby => ruby_version } }
    it_behaves_like "rbenvgem" do
      let(:rbenv) { "#{params[:root]}/versions/#{ruby_version}" }
    end
  end

end
