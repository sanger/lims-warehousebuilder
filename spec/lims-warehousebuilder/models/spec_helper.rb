require 'lims-warehousebuilder/spec_helper'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder

  shared_examples_for "copying historic row to current table" do
    it "copies the historic table row into the current table" do
      historic_row = object.save
      current_row = db[current_table.to_sym].where(:uuid => historic_row.uuid).first
      historic_row.values.each do |k,v|
        current_row[k].should == v
      end
    end
  end


  shared_examples_for "a warehouse model" do

    let(:historic_table) { "historic_#{model}s" }
    let(:current_table) { "current_#{model}s" }

    context "when saving a new object" do
      it "saves the object in the historic table" do
        expect { object.save }.to change { db[historic_table.to_sym].count }.by(1)
      end

      it "saves the object in the current table" do
        expect { object.save }.to change { db[current_table.to_sym].count }.by(1)
      end

      it_behaves_like "copying historic row to current table"
    end


    context "when updating an object" do
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

      it_behaves_like "copying historic row to current table"
    end


    context "when inserting a row in the current table with an existing internal_id" do
      let(:next_historic_id) do
        db[historic_table.to_sym].insert
        db[historic_table.to_sym].order(Sequel.desc(:internal_id)).first[:internal_id] + 1
      end

      before(:each) do
        db[current_table.to_sym].insert(:internal_id => next_historic_id)
      end

      it "removes the existing row with an identical internal_id and saves the new historic row" do
        expect do 
          object.save
        end.to change { db[current_table.to_sym].count }.by(0)
      end
      
      it_behaves_like "copying historic row to current table"
    end
  end
end
