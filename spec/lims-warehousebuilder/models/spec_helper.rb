require 'lims-warehousebuilder/spec_helper'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  shared_examples_for "a warehouse model" do

    before(:each) do
      @model_helper = Object.new.extend(Model)
      @model = @model_helper.model_for(model).new
    end

    context "new object" do
      it "saves the object in the historic table" do
        expect { object.save }.to change { db[historic_table.to_sym].count }.by(1)
      end

      it "saves the object in the current table" do
        expect { object.save }.to change { db[current_table.to_sym].count }.by(1)
      end
    end

    context "update object" do
      before(:each) do
        object.save
      end

      it "saves the updated object in the historic table" do
        expect { updated_object.save }.to change { db[historic_table.to_sym].count }.by(1)
      end

      it "replaces the object by the updated object in the current table" do
        expect { updated_object.save }.to change { db[current_table.to_sym].count }.by(0) 
      end
    end
  end
end
