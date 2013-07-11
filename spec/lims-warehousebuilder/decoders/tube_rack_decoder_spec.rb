require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder::Decoder
  describe "Tube rack decoder" do
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
end
