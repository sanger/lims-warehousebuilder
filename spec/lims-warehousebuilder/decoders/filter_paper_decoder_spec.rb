require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/json_decoder'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe "Decoder::FilterPaperDecoder" do

    context "foreach_s2_resource" do
      let(:payload) do
        {"filter_paper" => {
          "uuid" => "filter paper uuid",
          "aliquots" => [
            {"sample" => {"uuid" => "sample 1 uuid"}},
            {"sample" => {"uuid" => "sample 2 uuid"}}
          ]
        }}
      end
      let(:expected_resources) { ["filter_paper", "sample", "sample"] }
      let(:expected_mandatory_keys) { ["date", "user", "action", "ancestor_type", "ancestor_uuid"] }

      it_behaves_like "decoding resources"
    end
  end
end
