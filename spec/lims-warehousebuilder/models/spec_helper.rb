require 'lims-warehousebuilder/spec_helper'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder

  shared_examples_for "a warehouse model" do

    let(:historic_table) { "historic_#{model}s" }
    let(:current_table) { "current_#{model}s" }

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

      it "does not replace the internal_id in the current table" do
        old_id = db[current_table.to_sym].where(:uuid => object.uuid)
        updated_object.save
        db[current_table.to_sym].where(:uuid => object.uuid).should == old_id
      end
    end
  end
end
