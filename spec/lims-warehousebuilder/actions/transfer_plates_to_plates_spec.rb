require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/json_decoder'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe "TransferPlatesToPlates action" do
    include_context "use database"
    include_context "timecop"
    include_context "create payloads"

    let(:model) { "plate" }

    let(:transfers) {
      [{
        "source_uuid"     => source_plate_uuid,
        "source_location" => "A1",
        "target_uuid"     => target_plate_uuid,
        "target_location" => "B2",
        "fraction"        => 0.4,
        "aliquot_type"    => "DNA"
      }]
    }
    let(:full_payload) do
      {}.tap do |h|
        h["transfer_plates_to_plates"] = {
          "result"    => {
            "sources" => [
              source_plate_payload,
              target_plate_payload
            ],
            "targets" => [
              source_plate_payload,
              target_plate_payload
            ]
          },
          "transfers" => transfers
        }
        h["date"] = update_date
        h["user"] = update_user
      end
    end

    before do
      create_plate(source_plate_uuid, date, user, number_of_rows_plate, number_of_columns_plate).save
      create_plate(target_plate_uuid, date, user, number_of_rows_plate, number_of_columns_plate).save
      Model::Sample.new(:uuid => sample1_uuid).save
      Model::Sample.new(:uuid => sample2_uuid).save
      Model::SampleContainerHelper.new(:sample_uuid => sample1_uuid, :container_uuid => source_plate_uuid, :container_model => "plate").save
      Model::SampleContainerHelper.new(:sample_uuid => sample2_uuid, :container_uuid => source_plate_uuid, :container_model => "plate").save
    end

    let(:decoder) { Decoder::PlateDecoder.new(model, source_plate_payload["plate"], full_payload) }
    let(:result)  { decoder.call }

    it_behaves_like "a decoder"

    context "decoded resources" do
      it "returns decoded resources" do
        result.size.should == 1
      end

      it "updates the plate model" do
        result[0].should be_a(Model::Plate)
        result[0].updated_at.should == update_date
        result[0].updated_by.should == update_user
      end
    end
  end
end