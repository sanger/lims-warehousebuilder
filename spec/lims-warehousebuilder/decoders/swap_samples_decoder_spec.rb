require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/json_decoder'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe Decoder::SwapSamplesDecoder do
    include_context "use database"
    include_context "timecop"

    let(:model) { "swap_samples" }
    let(:tube_rack_uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:sample1_uuid) { "11111111-0000-0000-0000-111111111111" }
    let(:sample2_uuid) { "11111111-0000-0000-0000-222222222222" }
    let(:tube1_uuid) { "11111111-2222-3333-4444-666666666666" }
    let(:tube2_uuid) { "11111111-2222-3333-4444-777777777777" }
    let(:date) { Time.now.utc }
    let(:user) { "username" }
    let(:item_status) { "done" }
    let(:order_uuid) { "11111111-2222-3333-4444-888888888888" }
    let(:role) { "my role" }
    let(:pipeline) { "my pipeline" }

    let(:payload) do
      {}.tap do |h|
        h["date"] = date
        h["user"] = user
        h["parameters"] = [{
          "resource_uuid" => tube_rack_uuid,
          "swaps" => {sample1_uuid => sample2_uuid, sample2_uuid => sample1_uuid}
        }]
      end
    end

    let(:decoder) { described_class.new(model, payload) }
    let(:result) { decoder.call }

    before do
      described_class.any_instance.stub(:parent_key_for_uuid) { "tube_rack" }
      Model.model_for("tube").new(:uuid => tube1_uuid, :tube_rack_uuid => tube_rack_uuid).save 
      Model.model_for("tube").new(:uuid => tube2_uuid, :tube_rack_uuid => tube_rack_uuid).save 
      Model::SampleContainerHelper.new(:sample_uuid => sample1_uuid, :container_uuid => tube1_uuid, :container_model => "tube").save
      Model::SampleContainerHelper.new(:sample_uuid => sample2_uuid, :container_uuid => tube2_uuid, :container_model => "tube").save
      Model.model_for("item").new(:uuid => tube1_uuid, :status => item_status, :order_uuid => order_uuid, :role => role).save
      Model.model_for("item").new(:uuid => tube2_uuid, :status => item_status, :order_uuid => order_uuid, :role => role).save
      Model.model_for("order").new(:uuid => order_uuid, :pipeline => pipeline).save
      Model::Sample.new(:uuid => sample1_uuid).save
      Model::Sample.new(:uuid => sample2_uuid).save
    end

    it_behaves_like "a decoder"

    context "decoded resources" do
      it "returns decoded resources" do
        result.size.should == 4
      end

      it "returns sample container helper models" do
        result[0].should be_a(Model::SampleContainerHelper)
        result[0].sample_uuid.should == sample2_uuid
        result[0].container_uuid.should == tube1_uuid
        result[1].should be_a(Model::SampleContainerHelper)
        result[1].sample_uuid.should == sample1_uuid
        result[1].container_uuid.should == tube2_uuid
      end

      it "returns sample management activity models" do
        result[2].should be_a(Model::SampleManagementActivity)
        result[2].uuid.should == sample2_uuid
        result[2].tube_uuid.should == tube1_uuid
        result[3].should be_a(Model::SampleManagementActivity)
        result[3].uuid.should == sample1_uuid
        result[3].tube_uuid.should == tube2_uuid
      end
    end

    context "foreach_s2_resource" do
      let(:payload) do
        {"swap_samples" => {}}
      end

      let(:expected_mandatory_keys) { ["date", "user", "action"] }
      let(:expected_resources) { ["swap_samples"] }

      it_behaves_like "decoding resources"
    end
  end
end
