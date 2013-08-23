require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/json_decoder'
require 'lims-warehousebuilder/model'

module Lims::WarehouseBuilder
  describe Decoder::OrderDecoder do
    include_context "use database"
    include_context "timecop"

    let(:model) { "order" }
    let(:date) { Time.now.utc }
    let(:user) { "username" }
    let(:pipeline) { "dna+rna manual extraction" }
    let(:status) { "in_progress" }
    let(:cost_code) { "cost code" }
    let(:item_status) { "done" }
    let(:role) { "input_tube" }
    let(:tube_uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:sample_uuid) { "11111111-2222-3333-4444-666666666666" }
    let(:order_uuid) { "11111111-2222-3333-4444-777777777777" }
    let(:batch_uuid) { "11111111-2222-3333-4444-888888888888" }
    let(:payload) do
      {}.tap do |h|
        h["date"] = date.to_s
        h["user"] = user
        h["pipeline"] = pipeline
        h["status"] = status
        h["uuid"] = order_uuid
        h["cost_code"] = cost_code
        h["items"] = {
          role => [{"status" => item_status, "batch" => {"uuid" => batch_uuid}, "uuid" => tube_uuid}]
        }
      end
    end
    let(:decoder) { described_class.new(model, payload) }

    it_behaves_like "a decoder"

    context "decoded resources" do
      before do
        Model.model_for("tube").new(:uuid => tube_uuid).save
        Model::SampleContainerHelper.new(:sample_uuid => sample_uuid, :container_uuid => tube_uuid, :container_model => "tube").save
      end

      let(:result) { decoder.call }

      it "returns decoded resources" do
        result.size.should == 3
      end

      it "returns an order model" do
        order = result.first
        order.should be_a(Model::Order)        
        order.uuid.should == order_uuid 
        order.pipeline.should == pipeline
        order.status.should == status
        order.cost_code.should == cost_code
        order.created_at.to_s.should == date.to_s
        order.created_by.should == user
      end

      it "returns an item model" do
        item = result[1]
        item.should be_a(Model::Item)
        item.order_uuid.should == order_uuid
        item.role.should == role 
        item.uuid.should == tube_uuid
        item.batch_uuid.should == batch_uuid
        item.status.should == item_status
        item.created_at.to_s.should == date.to_s
        item.created_by.should == user
      end

      it "returns a sample_management_activity model" do
        activity = result[2]
        activity.should be_a(Model::SampleManagementActivity)
        activity.uuid.should == sample_uuid
        activity.order_uuid.should == order_uuid
        activity.process.should == pipeline
        activity.step.should == role
        activity.tube_uuid.should == tube_uuid
        activity.spin_column_uuid.should be_nil
        activity.user.should == user
        activity.status.should == item_status
        activity.current_from.to_s.should == date.to_s
      end
    end
  end
end
