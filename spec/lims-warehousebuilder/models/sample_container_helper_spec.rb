require 'lims-warehousebuilder/models/spec_helper'

module Lims::WarehouseBuilder
  describe Model::SampleContainerHelper do
    include_context "use database"

    let(:sample_uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:container_uuid) { "11111111-2222-3333-4444-666666666666" }
    let(:container_model) { "tube" }
    let(:object) { described_class.new(:sample_uuid => sample_uuid, :container_uuid => container_uuid, :container_model => container_model) }

    context "sample container model" do
      it "saves the object" do
        expect { object.save }.to change { db[:sample_container_helper].count }.by(1) 
      end

      it "doesn't save duplicate row" do
        expect do
          object.save
          object.save
        end.to raise_error(Sequel::HookFailed) 
      end
    end

    context "sample container usage" do
      let(:sample2_uuid) { "11111111-2222-3333-4444-777777777777" }
      let(:dummy_container_uuid) { "11111111-2222-3333-4444-888888888888" }
      let(:object2) { described_class.new(:sample_uuid => sample2_uuid, :container_uuid => container_uuid, :container_model => container_model) }
      before(:each) do
        object.save
        object2.save
      end

      it "returns the right sample info from the container uuid" do
        described_class.samples_info_by_item_uuid(container_uuid).should == [
          {:sample_uuid => sample_uuid, :container_uuid => container_uuid, :container_model => container_model}, 
          {:sample_uuid => sample2_uuid, :container_uuid => container_uuid, :container_model => container_model}
        ]
      end

      it "raises a NotFound exception if there isn't any sample uuid associated to the container uuid" do
        described_class.samples_info_by_item_uuid(dummy_container_uuid).should == []
      end
    end
  end
end
