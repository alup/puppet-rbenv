require 'spec_helper'

describe 'rbenv' do
  it { should include_class('git') }
  it { should include_class('curl') }
  it { should include_class('rbenv::install') }

end
