require 'spec_helper'

describe 'rbenv' do
  it { should include_class('rbenv::dependencies') }
  it { should include_class('rbenv::install') }

end
