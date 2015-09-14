require 'spec_helper'

# Write unit tests with ChefSpec - https://github.com/sethvargo/chefspec#readme
describe 'graphite::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'logs a sample message' do
    expect(chef_run).to write_log "The graphite::default recipe doesn't do anything"
  end
end
