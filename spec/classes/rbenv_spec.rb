require 'spec_helper'

describe 'rbenv' do
  let(:title) { 'rbenv' }
  let(:params) { { :user => 'tester' } }

  it { should include_class('rbenv::dependencies') }

end
