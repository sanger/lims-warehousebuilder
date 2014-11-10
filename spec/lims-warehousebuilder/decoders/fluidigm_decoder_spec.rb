require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/json_decoder'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe "Decoder::FluidigmDecoder" do

    context "foreach_s2_resource" do
      let(:payload) do
        {"fluidigm" => {
          "uuid" => "fluidigm uuid",
          "number_of_rows" => 16,
          "number_of_columns" => 12,
          "fluidigm_wells" => {
            "S1" => [{"sample" => {"uuid" => "sample 1 uuid"}}],
            "A1" => [{"snp_assay" => {"uuid" => "snp_assay 1 uuid"}}]
          }
        }}
      end
      let(:expected_resources) { ["fluidigm", "sample", "snp_assay"] }
      let(:expected_mandatory_keys) { ["date", "user", "action", "ancestor_type", "ancestor_uuid"] }

      it_behaves_like "decoding resources"
    end
  end
end
