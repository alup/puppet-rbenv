require 'spec_helper'

describe 'rbenv::compile', :type => :define do
  let(:user)         { 'tester' }
  let(:ruby_version) { '1.9.3-p125' }
  let(:title)        { "rbenv::compile::#{user}::#{ruby_version}" }
  let(:dot_rbenv)    { "/home/#{user}/.rbenv" }
  let(:params)       { {:user => user, :ruby => ruby_version, :set_default => true } }

  it "installs ruby of the chosen version" do
    should contain_exec("rbenv::compile #{user} #{ruby_version}").
      with_command("rbenv install #{ruby_version}; touch #{dot_rbenv}/.rehash")
  end

  it "issues a rehash command" do
    should contain_exec("rbenv::rehash #{user}").
      with_command("rbenv rehash; rm -f #{dot_rbenv}/.rehash")
  end

  it "sets the global ruby version for the specific user" do
    should contain_file("rbenv::global #{user}").
      with_content("#{ruby_version}\n")
  end

  context 'with source defined' do
    let(:ruby_version) { 'patched-ree' }
    let(:target_path)  { "#{dot_rbenv}/plugins/ruby-build/share/ruby-build/#{ruby_version}" }
    let(:params)       { {:user => user, :ruby => ruby_version, :source => definition} }

    context 'puppet' do
      let(:definition)   { 'puppet:///custom-definition' }
      it 'copies the file to the right path' do
        should contain_file("rbenv::definition #{user} #{ruby_version}").with(
          :path => target_path,
          :source  => definition
        )
      end
    end

    context 'http' do
      let(:definition) { 'http://gist.com/ree' }
      it 'downloads file to the right path' do
        should contain_exec("rbenv::definition #{user} #{ruby_version}").with(
          :command => "wget #{definition} -O #{target_path}"
        )
      end
    end

    context 'https' do
      let(:definition) { 'https://gist.com/ree' }
      it 'downloads file to the right path' do
        should contain_exec("rbenv::definition #{user} #{ruby_version}").with(
          :command => "wget #{definition} -O #{target_path}"
        )
      end
    end
  end
end
