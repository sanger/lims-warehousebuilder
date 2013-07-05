require 'lims-warehousebuilder/models/spec_helper'

module Lims::WarehouseBuilder
  describe Model::Barcode do
    include_context "use database"
    include_context "timecop"

    let(:model) { "barcode" }
    let(:uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:created_at) { Time.now.utc }
    let(:created_by) { "username" }
    let(:ean13_barcode) { "ean13_barcode" }
    let(:sanger_barcode) { "sanger_barcode" }
    let(:barcoded_resource_uuid) { "11111111-2222-3333-4444-666666666666" }
    let(:position) { "position" }

    let(:object) do 
      described_class.new.tap do |s|
        s.uuid = uuid
        s.ean13_barcode = ean13_barcode
        s.sanger_barcode = sanger_barcode
        s.created_at = created_at
        s.created_by = created_by
      end
    end

    let(:updated_object) do
      Model.clone_model_object(object).tap do |s|
        s.barcoded_resource_uuid = barcoded_resource_uuid
        s.position = position
      end
    end

    it_behaves_like "a warehouse model"

    context "barcode accessors" do
      context "valid" do
        before do
          object.save
        end

        it "gets back the barcode by sanger barcode" do
          barcode = described_class.barcode_by_sanger_barcode(sanger_barcode)
          barcode.should be_a(Model::Barcode)
          (barcode.values - [:internal_id]).should == (object.values - [:internal_id])
        end

        it "gets back the barcode by ean13 barcode" do
          barcode = described_class.barcode_by_ean13_barcode(ean13_barcode)
          barcode.should be_a(Model::Barcode)
          (barcode.values - [:internal_id]).should == (object.values - [:internal_id])
        end
      end

      context "invalid" do
        before do
          described_class.new({:uuid => uuid, :sanger_barcode => "dummy", :ean13_barcode => "dummy"}).save
        end

        it "raises a NotFound error for unkown sanger barcode" do
          expect do
            described_class.barcode_by_sanger_barcode(sanger_barcode)
          end.to raise_error(Model::NotFound)
        end

        it "raises a NotFound error for unknown ean13_barcode" do
          expect do
            described_class.barcode_by_ean13_barcode(ean13_barcode)
          end.to raise_error(Model::NotFound)
        end
      end
    end
  end
end
