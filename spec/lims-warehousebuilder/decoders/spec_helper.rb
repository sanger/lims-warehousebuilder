require 'lims-warehousebuilder/spec_helper'
require 'lims-warehousebuilder/json_decoder'
require 'lims-warehousebuilder/builder'

shared_examples_for "a decoder" do
  it "can be called" do
    decoder.respond_to?(:call)
  end

  it "returns an array of sequel models" do
    decoder.call.should be_a(Array)
    decoder.call.each do |model|
      model.should be_a(Sequel::Model)
    end
  end
end

shared_examples_for "decoding resources" do
  let(:decoded_models) do
    [].tap do |models|
      Lims::WarehouseBuilder::Decoder::JsonDecoder.foreach_s2_resource(payload) do |model, value|
        models << model
      end
    end
  end

  let(:decoded_resources) do
    [].tap do |r|
      Lims::WarehouseBuilder::Decoder::JsonDecoder.foreach_s2_resource(payload) do |model, value|
        r << value
      end
    end
  end

  it "decodes the right models" do
    decoded_models.should == expected_resources
  end

  it "decodes resource adding mandatory attributes" do
    decoded_resources.each do |r|
      expected_mandatory_keys.each do |k|
        r.should include(k)
      end
    end
  end
end
