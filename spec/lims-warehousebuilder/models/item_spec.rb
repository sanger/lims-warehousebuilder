require 'lims-warehousebuilder/models/spec_helper'

module Lims::WarehouseBuilder
  describe Model::Item do
    include_context "use database"
    include_context "timecop"

    let(:model) { "item" }
    let(:uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:created_at) { Time.now.utc }
    let(:created_by) { "username" }
    let(:role) { "my role" }
    let(:batch_uuid) { "11111111-2222-3333-4444-777777777777" }
    let(:status) { "in_progress" }
    let(:order_uuid) { "11111111-2222-3333-4444-666666666666" }

    let(:object) do 
      described_class.new.tap do |s|
        s.uuid = uuid
        s.role = role
        s.batch_uuid = batch_uuid
        s.status = status
        s.created_at = created_at
        s.created_by = created_by
        s.set_order_uuid(order_uuid)
      end
    end

    let!(:order) { Model::Order.new(:uuid => order_uuid).save }

    let(:updated_object) do
      Model.clone_model_object(object).tap do |s|
        s.status = "done"
      end
    end

    it_behaves_like "a warehouse model"

    context "item accessors" do
      context "valid" do
        before do
          object.save
        end

        it "gets back the item by uuid" do
          item = described_class.item_by_uuid(uuid)
          item.should be_a(Model::Item)
          (item.values - [:internal_id]).should == (object.values - [:internal_id])
        end
      end

      context "invalid" do
        it "raises a NotFound error for unkown sanger barcode" do
          expect do
            described_class.item_by_uuid(uuid)
          end.to raise_error(Model::NotFound)
        end
      end
    end
  end
end
