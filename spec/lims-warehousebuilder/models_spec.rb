require 'lims-warehousebuilder/spec_helper'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe Model do

    let(:model) do
      Class.new { include Model }.new
    end

    context "basic functionalities" do
      include_context "use database"

      it "responds to basic methods" do
        Model.should respond_to(:model_for, :model_by_uuid, :clone_model_object)
        model.should respond_to(:prepared_model)
      end
    end

    context "with an existing model" do
      let(:modelname) { "sample" }   

      it "returns a sequel model" do
        Model.model_for(modelname).should == Model::Sample
      end
    end

    context "with an unknown model" do
      let(:dummyname) { "dummy" }

      it "raises an exception" do
        expect {
          Model.model_for(dummyname)
        }.to raise_error(Model::UnknownModel)
      end
    end
  end
end
