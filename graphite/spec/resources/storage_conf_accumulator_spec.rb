require "spec_helper"
load_resource("graphite", "storage_conf_accumulator")
require_relative "../../libraries/mixins"
require_relative "../../libraries/provider_storage_conf_accumulator"

describe Chef::Resource::GraphiteStorageConfAccumulator do

  let(:resource_name) { "foobar" }

  it "sets the name attribute to name" do
    expect(resource.name).to eq("foobar")
  end

  it "attribute file_resource defaults to file[storage-schemas.conf]" do
    expect(resource.file_resource).to eq("file[storage-schemas.conf]")
  end

  it "attribute file_resource takes a String value" do
    resource.file_resource("blahblah")

    expect(resource.file_resource).to eq("blahblah")
  end

  it "action defaults to :create" do
    expect(resource.action).to eq(:create)
  end

  it "provider defaults to GraphiteStorageConfAccumulator" do
    expect(resource.provider).to eq(Chef::Provider::GraphiteStorageConfAccumulator)
  end
end
