require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe Decoder::GelDecoder do

    let(:model) { "gel" }
    let(:date) { Time.now.utc }
    let(:user) { "user" }
    let(:gel_uuid) { "gel_uuid" }
    let(:decoder) { described_class.new(model, payload) }
    let(:result) { decoder.call }


    context "foreach_s2_resources" do
      let(:payload) do
        {"gel" => {
          "uuid" => gel_uuid,
          "windows" => {
            "A1" => {"sample" => {"uuid" => "sample uuid 1"}},
            "B1" => {"sample" => {"uuid" => "sample uuid 2"}}
          }
        }}
      end
      let(:expected_resources) { ["gel", "sample", "sample"] }
      let(:expected_mandatory_keys) { ["date", "user", "action", "ancestor_type", "ancestor_uuid"] }

      it_behaves_like "decoding resources"
    end


    context "decoded resources" do
      let(:payload) do
        {}.tap do |h|
          h["date"] = date.to_s
          h["user"] = user
          h["uuid"] = gel_uuid
        end
      end

      it_behaves_like "a decoder"

      it "returns decoded gel" do
        result.size.should == 1
        result[0].should be_a(Model::Gel)
        result[0].created_at.to_s.should == date.to_s
        result[0].created_by.should == user
      end
    end


    context "with a gel image" do
      let(:image) { "image" }
      let(:payload) do
        {}.tap do |h|
          h["date"] = date.to_s
          h["user"] = user
          h["uuid"] = gel_uuid
          h["out_of_bounds"] = {"image" => image}
        end       
      end

      context "when the image is new" do
        it "returns a gel, a gel image and a gel image metadata" do
          result.size.should == 3
          gel, gel_image, gel_image_metadata = result[0], result[1], result[2]
          gel.should be_a(Model::Gel)
          gel_image.should be_a(Model::GelImage)
          gel_image.internal_id.should be_nil
          gel_image.image.should == image
          gel_image_metadata.should be_a(Model::GelImageMetadata)
          gel_image_metadata.internal_id.should be_nil
          gel_image_metadata.instance_variable_get("@gel_image").should == gel_image
          gel_image_metadata.uuid.should == gel_uuid
        end
      end

      context "when the image needs to be updated" do
        before do
          objects = decoder.call
          objects.each { |o| o.save }
        end

        let(:new_image) { "new image" }
        let(:payload_with_new_image) { payload.tap { |p| p["out_of_bounds"] = {"image" => new_image}}}
        let(:new_decoder) { described_class.new(model, payload_with_new_image) }

        it "returns an updated gel image and gel image metadata model with existing primary keys" do
          result = new_decoder.call 
          gel_image, gel_image_metadata = result[0], result[1]
          gel_image.internal_id.should_not be_nil
          gel_image.image.should == new_image
          gel_image_metadata.internal_id.should_not be_nil
          gel_image_metadata.uuid.should == gel_uuid
          gel_image_metadata.gel_image.should == gel_image
        end
      end
    end
  end
end
