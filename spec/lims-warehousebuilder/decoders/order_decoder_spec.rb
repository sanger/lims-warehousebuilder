require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder::Decoder
  describe OrderDecoder do
    include_context "use database"

    let(:model) { "order" }
    let(:date) { Time.now.utc }
    let(:user) { "username" }
    let(:items) { {} }
    let(:pipeline) { "dna+rna manual extraction" }
    let(:status) { "in_progress" }
    let(:cost_code) { "cost code" }
    let(:payload) do
      {}.tap do |h|
        h["date"] = date.to_s
        h["user"] = user
        h["items"] = items
        h["pipeline"] = pipeline
        h["status"] = status
        h["cost_code"] = cost_code
      end
    end
    let(:decoder) { described_class.new(model, payload) }

    it_behaves_like "a decoder"
  end
end
