require 'lims-warehousebuilder/spec_helper'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe Model do

    before(:each) do
      @subject = Object.new
      @subject.extend(described_class)
    end

    context "basic functionalities" do
      include_context "use database"

      it "responds to basic methods" do
        @subject.should respond_to(
          :model_for,
          :model_for_uuid,
          :prepared_model,
          :clone_model_object
        )
      end
    end

    context "with an existing model" do
      let(:modelname) { "sample" }   

      it "returns a sequel model" do
        @subject.model_for(modelname).should == Model::Sample
      end
    end

    context "with an unknown model" do
      let(:dummyname) { "dummy" }

      it "raises an exception" do
        expect {
          @subject.model_for(dummyname)
        }.to raise_error(Model::UnknownModel)
      end
    end
  end
end
