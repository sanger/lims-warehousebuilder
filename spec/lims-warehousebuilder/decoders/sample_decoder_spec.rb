require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder::Decoder
  describe SampleDecoder do
    include_context "use database"

    let(:model) { "sample" }
    let(:uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:ancestor_uuid) { mock(:ancestor_uuid) }
    let(:date) { Time.now.utc }
    let(:payload) do 
      {}.tap do |h|
        h["uuid"] = uuid
        h["date"] = date.to_s
        h["ancestor_uuid"] = ancestor_uuid
      end
    end
    let(:decoder) { described_class.new(model, payload) }

    context "new sample" do
      let(:expected_models) {[
        Lims::WarehouseBuilder::Model::Sample, 
        Lims::WarehouseBuilder::Model::SampleContainerHelper, 
        Lims::WarehouseBuilder::Model::SampleManagementActivity
      ]}

      it_behaves_like "a decoder"

      it "returns an array with a sample model, a sample container helper model and a sample management activity model" do
        decoder.call.each do |model|
          expected_models.should include(model.class)
        end
      end
    end

    context "old sample" do
      let(:expected_models) {[
        Lims::WarehouseBuilder::Model::Sample,
        Lims::WarehouseBuilder::Model::SampleContainerHelper
      ]}

      before(:each) do
        Lims::WarehouseBuilder::Model::SampleManagementActivity.new(:uuid => uuid).save      
      end

      it_behaves_like "a decoder"

      it "returns an array without the initial sample management activity model" do
        decoder.call.each do |model|
          expected_models.should include(model.class)
        end
      end
    end
  end
end
