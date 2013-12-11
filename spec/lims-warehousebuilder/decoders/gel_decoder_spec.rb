require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe "Decoder::GelDecoder" do

    context "foreach_s2_resources" do
      let(:payload) do
        {"gel" => {
          "uuid" => "gel uuid",
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
  end
end
