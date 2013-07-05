require 'lims-warehousebuilder/models/spec_helper'

module Lims::WarehouseBuilder
  describe Model::Tube do
    include_context "use database"
    include_context "timecop"

    let(:model) { "tube" }
    let(:uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:type) { "my type" }
    let(:max_volume) { 100 }
    let(:created_at) { Time.now.utc }
    let(:created_by) { "username" }
    let(:tube_rack_uuid) { "11111111-2222-3333-4444-666666666666" }
    let(:location) { "A1" }

    let!(:tube_rack) { Model.model_for("tube_rack").new(:uuid => tube_rack_uuid).save }

    let(:object) do 
      described_class.new.tap do |s|
        s.uuid = uuid
        s.type = type
        s.max_volume = max_volume
        s.created_at = created_at
        s.created_by = created_by
        s.location = location
        #s.set_tube_rack_uuid(tube_rack_uuid)
      end
    end

    it "set the tube rack id" do
      pending
    end

    let(:updated_object) do
      Model.clone_model_object(object).tap do |s|
        s.type = "eppendorf"
      end
    end

    it_behaves_like "a warehouse model"

    it "returns a tube given its uuid" do
      object.save
      described_class.tube_by_uuid(uuid).should be_a(Model::Tube)
      (described_class.tube_by_uuid(uuid).values - [:internal_id]).should == (object.values - [:internal_id]) 
    end

    it "raises an error if the tube cannot be found" do
      expect do
        described_class.tube_by_uuid(uuid)
      end.to raise_error(Model::NotFound)
    end
  end
end
