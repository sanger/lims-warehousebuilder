require 'lims-warehousebuilder/models/spec_helper'

module Lims::WarehouseBuilder
  describe "Model::SnpAssay" do
    include_context "use database"
    include_context "timecop"

    let(:model) { "snp_assay" }
    let(:uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:name) { "snp_assay 0" }
    let(:allele_x) { "A" }
    let(:allele_y) { "G" }
    let(:created_at) { Time.now.utc }
    let(:created_by) { "username" }

    let(:object) do 
      Model.model_for(model).new.tap do |s|
        s.uuid = uuid
        s.name = name
        s.allele_x = allele_x
        s.allele_y = allele_y
        s.created_at = created_at
        s.created_by = created_by
      end
    end

    let(:updated_object) do
      Model.clone_model_object(object)
    end

    it_behaves_like "a warehouse model"

    it "returns a snp_assay given its uuid" do
      object.save
      Model::SnpAssay.snp_assay_by_uuid(uuid).should be_a(Model::SnpAssay)
      (Model::SnpAssay.snp_assay_by_uuid(uuid).values - [:internal_id]).should == (object.values - [:internal_id]) 
    end

    it "raises an error if the snp_assay cannot be found" do
      expect do
        Model::SnpAssay.snp_assay_by_uuid(uuid)
      end.to raise_error(Model::NotFound)
    end
  end
end
