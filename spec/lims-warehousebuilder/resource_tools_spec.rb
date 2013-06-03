require 'lims-warehousebuilder/spec_helper'
require 'lims-warehousebuilder/resource_tools'

module Lims::WarehouseBuilder::ResourceTools
  describe "Nested Hash" do
    let(:nested_hash) { {:a => 1, :b => {:c => 2, :d => {:e => 3, :f => 4}, :g => 5}, :h => 6, :i => nil} }
    before(:each) do
      @object = Object.new
      @object.extend(NestedHash)
    end

    it "seeks the value of :e in the hash" do
      @object.seek(nested_hash, "b__d__e").should == 3
    end

    it "seeks the value of :g in the hash" do
      @object.seek(nested_hash, "b__g").should == 5
    end

    it "seeks the value of :h in the hash" do
      @object.seek(nested_hash, "h").should == 6
    end

    it "seeks the value of inexistant key" do
      @object.seek(nested_hash, "i__z").should == nil
    end
  end
end
