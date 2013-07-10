require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder::Decoder
  describe "Tube decoder" do
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
end
