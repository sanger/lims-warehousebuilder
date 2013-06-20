require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder::Decoder
  describe LabellableDecoder do
    include_context "use database"

    let(:model) { "labellable" }
    let(:date) { Time.now.utc }
    let(:user) { "username" }
    let(:uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:name) { "11111111-2222-3333-4444-666666666666" }
    let(:type) { "resource" }
    let(:payload) do
      {}.tap do |h|
        h["date"] = date.to_s
        h["user"] = user
        h["uuid"] = uuid
        h["name"] = name
        h["type"] = type
        h["labels"] = {"front barcode" => {"value" => "123456", "type" => "sanger-barcode"}}
      end
    end
    let(:decoder) { described_class.new(model, payload) }

    before do
      Lims::WarehouseBuilder::Model::Barcode.new({:uuid => "11111111-0000-0000-0000-111111111111", :sanger_barcode => "123456"}).save
    end

    it_behaves_like "a decoder"

    it "returns an array of Barcode objects" do
      decoder.call.each do |model|
        model.should be_a(Lims::WarehouseBuilder::Model::Barcode)
      end
    end
  end
end
