require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/json_decoder'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe Decoder::TubeRackDecoder do

    context "foreach_s2_resource" do
      let(:payload) do
        {"tube_rack" => {
          "uuid" => "tube rack uuid",
          "tubes" => {
            "A1" => {"uuid" => "tube 1 uuid", "aliquots" => [{"sample" => {"uuid" => "sample 1 uuid"}}]},
            "G10" => {"uuid" => "tube 2 uuid", "aliquots" => [{"sample" => {"uuid" => "sample 2 uuid"}}]},
          }
        }}
      end
      let(:expected_resources) { ["tube_rack", "tube", "sample", "tube", "sample"] }
      let(:expected_mandatory_keys) { ["date", "user", "action", "ancestor_type", "ancestor_uuid"] }

      it_behaves_like "decoding resources"
    end

    context "decoded resources" do
      let(:model) { "tube_rack" }
      let(:date) { Time.now.utc }
      let(:user) { "user" }
      let(:payload) do 
        {}.tap do |h|
          h["uuid"] = "tube_rack_uuid"
          h["date"] = date.to_s
          h["user"] = user
        end
      end
      let(:decoder) { described_class.new(model, payload, payload) }
      let(:result) { decoder.call({:action => "delete"}) }

      context "delete tube rack" do
        it "returns a tube rack model setting deleted_at and deleted_by" do
          result[0].should be_a(Model::TubeRack)
          result[0].deleted_at.to_s.should == date.to_s
          result[0].deleted_by.should == user
        end
      end
    end
  end
end
