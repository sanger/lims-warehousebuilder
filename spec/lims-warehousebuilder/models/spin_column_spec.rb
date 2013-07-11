require 'lims-warehousebuilder/models/spec_helper'

module Lims::WarehouseBuilder
  describe "Model::SpinColumn" do
    include_context "use database"
    include_context "timecop"

    let(:model) { "spin_column" }
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
      Model.clone_model_object(object)
    end

    it_behaves_like "a warehouse model"
  end
end
