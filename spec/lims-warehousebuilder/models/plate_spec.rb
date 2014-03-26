require 'lims-warehousebuilder/models/spec_helper'

module Lims::WarehouseBuilder
  describe "Model::Plate" do
    include_context "use database"
    include_context "timecop"

    let(:model) { "plate" }
    let(:uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:created_at) { Time.now.utc }
    let(:created_by) { "username" }
    let(:number_of_rows) { 8 }
    let(:number_of_columns) { 12 }

    let(:object) do 
      Model.model_for(model).new.tap do |s|
        s.uuid = uuid
        s.created_at = created_at
        s.created_by = created_by
        s.number_of_rows = number_of_rows
        s.number_of_columns = number_of_columns
      end
    end

    let(:updated_object) do
      Model.clone_model_object(object).tap do |s|
      end
    end

    it_behaves_like "a warehouse model"

    it "returns a plate given its uuid" do
      object.save
      Model::Plate.plate_by_uuid(uuid).should be_a(Model::Plate)
      (Model::Plate.plate_by_uuid(uuid).values - [:internal_id]).should == (object.values - [:internal_id]) 
    end

    it "raises an error if the plate cannot be found" do
      expect do
        Model::Plate.plate_by_uuid(uuid)
      end.to raise_error(Model::NotFound)
    end
  end
end
