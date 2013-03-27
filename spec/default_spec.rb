require 'chefspec'

describe 'gitlabhq::default' do
  let(:chef_runner) { ChefSpec::ChefRunner.new }
  let(:chef_run) { chef_runner.converge 'gitlabhq::default' }

  it 'should do something' do
    pending 'fill tests'
  end
end
