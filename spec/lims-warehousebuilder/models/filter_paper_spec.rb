require 'lims-warehousebuilder/models/spec_helper'

module Lims::WarehouseBuilder
  describe "Model::FilterPaper" do
    include_context "use database"
    include_context "timecop"

    let(:model) { "filter_paper" }
    let(:uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:created_at) { Time.now.utc }
    let(:created_by) { "username" }

    let(:object) do 
      Model.model_for(model).new.tap do |s|
        s.uuid = uuid
        s.created_at = created_at
        s.created_by = created_by
      end
    end

    let(:updated_object) do
      Model.clone_model_object(object).tap do |s|
      end
    end

    it_behaves_like "a warehouse model"

    it "returns a filter paper given its uuid" do
      object.save
      Model::FilterPaper.filter_paper_by_uuid(uuid).should be_a(Model::FilterPaper)
      (Model::FilterPaper.filter_paper_by_uuid(uuid).values - [:internal_id]).should == (object.values - [:internal_id]) 
    end

    it "raises an error if the filter paper cannot be found" do
      expect do
        Model::FilterPaper.filter_paper_by_uuid(uuid)
      end.to raise_error(Model::NotFound)
    end
  end
end
