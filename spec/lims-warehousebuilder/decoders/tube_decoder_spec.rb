require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe Decoder::TubeDecoder do
    context "foreach_s2_resources" do
      let(:payload) do
        {"tube" => {
          "uuid" => "tube uuid",
          "aliquots" => [
            {"sample" => {"uuid" => "sample 1 uuid"}},
            {"sample" => {"uuid" => "sample 2 uuid"}}
          ]
        }}
      end
      let(:expected_resources) { ["tube", "sample", "sample"] }
      let(:expected_mandatory_keys) { ["date", "user", "action", "ancestor_type", "ancestor_uuid"] }

      it_behaves_like "decoding resources"
    end

    context "decoded resources" do
      let(:model) { "tube" }
      let(:date) { Time.now.utc }
      let(:user) { "user" }
      let(:tube_uuid) { "tube_uuid" }
      let(:tube_rack_uuid) { "tube_rack_uuid" }
      let(:location) { "A1" }
      let(:payload) do
        {}.tap do |h|
          h["date"] = date.to_s
          h["user"] = user
          h["uuid"] = tube_uuid
          h["ancestor_type"] = "tube_rack"
          h["ancestor_uuid"] = tube_rack_uuid
          h["location"] = location
        end
      end

      before do
        Model::TubeRack.new(:uuid => tube_rack_uuid).save
      end

      let(:decoder) { described_class.new(model, payload, payload) }
      let(:result) { decoder.call }

      it_behaves_like "a decoder"

      it "returns decoded tube" do
        result.size.should == 1
        result[0].location.should == location
        result[0].tube_rack_uuid.should == tube_rack_uuid
        result[0].created_at.to_s.should == date.to_s
        result[0].created_by.should == user
      end
    end
  end
end
