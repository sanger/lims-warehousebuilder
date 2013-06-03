require 'lims-warehousebuilder/models/spec_helper'

module Lims::WarehouseBuilder
  describe "Tube" do
    include_context "use database"

    let(:model) { "tube" }
    let(:historic_table) { "historic_tubes" }
    let(:current_table) { "current_tubes" }
    let(:uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:created_at) { Time.now.utc }
    let(:created_by) { "username" }

    let(:object) do 
      @model.tap do |s|
        s.uuid = uuid
        s.created_at = created_at
        s.created_by = created_by
      end
    end

    let(:updated_object) do
      @model_helper.clone_model_object(object).tap do |s|
        s.type = "eppendorf"
      end
    end

    it_behaves_like "a warehouse model"
  end
end
