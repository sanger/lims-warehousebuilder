require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/json_decoder'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe "TransferPlatesToPlates action" do
    include_context "use database"
    include_context "timecop"

    def create_plate(uuid, date, user, number_of_rows, number_of_columns)
      Model.model_for("plate").new(
        :uuid               => source_plate_uuid,
        :created_at         => date,
        :created_by         => user,
        :number_of_rows     => number_of_rows,
        :number_of_columns  => number_of_columns)
    end

    let(:model) { "plate" }
    let(:source_plate_uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:target_plate_uuid) { "11111111-2222-3333-4444-666666666666" }
    let(:sample1_uuid) { "11111111-0000-0000-0000-111111111111" }
    let(:sample2_uuid) { "11111111-0000-0000-0000-222222222222" }
    let(:date) { Time.now.utc }
    let(:update_date) { Time.now.utc + 100 }
    let(:user) { "username" }
    let(:update_user) { "update user" }
    let(:number_of_rows) { 8 }
    let(:number_of_columns) { 12 }

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
    let(:source_plate_payload) do
      { "plate" => {
          "uuid" => source_plate_uuid,
          "type" => "plate type",
          "number_of_rows" => 8,
          "number_of_columns" => 12,
          "date" => update_date,
          "user" => update_user
        }
      }
    end
    let(:target_plate_payload) do
      { "plate" => {
          "uuid" => target_plate_uuid,
          "type" => "plate type",
          "number_of_rows" => 8,
          "number_of_columns" => 12,
          "date" => update_date,
          "user" => update_user
        }
      }
    end

    before do
      create_plate(source_plate_uuid, date, user, number_of_rows, number_of_columns).save
      create_plate(target_plate_uuid, date, user, number_of_rows, number_of_columns).save
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