require 'lims-warehousebuilder/models/spec_helper'

module Lims::WarehouseBuilder
  describe Model::Order do
    include_context "use database"
    include_context "timecop"

    let(:model) { "order" }
    let(:uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:pipeline) { "my pipeline" }
    let(:status) { "in_progress" }
    let(:cost_code) { "cost code" }
    let(:created_at) { Time.now.utc }
    let(:created_by) { "username" }

    let(:object) do 
      described_class.new.tap do |s|
        s.uuid = uuid
        s.pipeline = pipeline
        s.status = status
        s.cost_code = cost_code
        s.created_at = created_at
        s.created_by = created_by
      end
    end

    let(:updated_object) do
      Model.clone_model_object(object).tap do |s|
        s.status = "done"
      end
    end

    it_behaves_like "a warehouse model"

    context "order accessor" do
      context "valid" do
        before do
          object.save
        end

        let(:order_id) { db[:current_orders].where(:uuid => uuid).first[:internal_id] }

        it "gets back the order by id" do
          order = described_class.order_by_id(order_id)
          order.should be_a(Model::Order)
          (order.values - [:internal_id]).should == (object.values - [:internal_id])
        end
      end

      context "invalid" do
        it "raises a NotFound error for unkown order" do
          expect do
            described_class.order_by_id(1)
          end.to raise_error(Model::NotFound)
        end
      end
    end
  end
end
