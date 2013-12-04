require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/json_decoder'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe "Decoder::SnpAssayDecoder" do

    let(:model)     { "snp_assay" }
    let(:uuid)      { "11111111-2222-3333-4444-555555555555" }
    let(:user)      { "user" }
    let(:name)      { "snp_assay name" }
    let(:allele_x)  { "A" }
    let(:allele_y)  { "T" }
    let(:date) { Time.now.utc }

    context "foreach_s2_resource" do
      let(:payload) do
        { "snp_assay" => {
          "uuid" => uuid,
          "name" => name,
          "allele_x" => allele_x,
          "allele_y" => allele_y
        }}
      end
      let(:expected_resources) { ["snp_assay"] }
      let(:expected_mandatory_keys) { ["date", "user", "action"] }

      it_behaves_like "decoding resources"
    end

    context "Sample payload included in other S2 resource" do
      let(:payload) do 
        {}.tap do |h|
          h["uuid"] = uuid
          h["name"] = name
          h["allele_x"] = allele_x
          h["allele_y"] = allele_y
          h["date"] = date.to_s
          h["user"] = user
        end
      end
      let(:decoder) { Decoder::JsonDecoder.new(model, payload) }
      let(:result) { decoder.call }

      it_behaves_like "a decoder"

    end
  end
end
