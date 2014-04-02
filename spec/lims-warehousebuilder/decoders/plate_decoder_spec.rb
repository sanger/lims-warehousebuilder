require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/json_decoder'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe "Decoder::PlateDecoder" do

    context "foreach_s2_resource" do
      let(:payload) do
        {"plate" => {
          "uuid" => "plate uuid",
          "number_of_rows" => 8,
          "number_of_columns" => 12,
          "wells" => {
            "A1" => [{"sample" => {"uuid" => "sample 1 uuid"}}],
            "B1" => [{"sample" => {"uuid" => "sample 2 uuid"}}]
          }
        }}
      end
      let(:expected_resources) { ["plate", "sample", "sample"] }
      let(:expected_mandatory_keys) { ["date", "user", "action", "ancestor_type", "ancestor_uuid"] }

      it_behaves_like "decoding resources"
    end
  end
end
