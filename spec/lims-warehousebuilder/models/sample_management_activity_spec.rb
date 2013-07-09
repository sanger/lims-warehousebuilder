require 'lims-warehousebuilder/models/spec_helper'

module Lims::WarehouseBuilder
  describe Model::SampleManagementActivity do
    include_context "use database"
    include_context "timecop"

    let(:model) { "sample_management_activity" }
    let(:uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:process) { "dna+rna manual extraction" }
    let(:step) { "initial tube" }
    let(:status) { "in_progress" }
    let(:created_at) { Time.now.utc }
    let(:created_by) { "username" }

    let!(:sample) do
      Model::Sample.new.tap do |s|
        s.uuid = uuid
      end.save
    end

    let(:order_uuid) { "11111111-2222-3333-4444-666666666666" }
    let!(:current_order_id) do
      historic_order = Model.model_for("order").new.tap do |o|
        o.uuid = order_uuid
      end.save
      Model.model_by_uuid(order_uuid, "order").internal_id
    end

    let(:tube_uuid) { "11111111-2222-3333-4444-777777777777" }
    let!(:tube_id) do
      Model.model_for("tube").new.tap do |t|
        t.uuid = tube_uuid
      end.save.internal_id
    end

    let(:activity) do
      described_class.new.tap do |a|
        a.uuid = uuid
        a.order_uuid = order_uuid
        a.set_sample_container_uuid!(tube_uuid, "tube")
        a.process = process
        a.step = step
        a.user = created_by
        a.status = status
        a.current_from = created_at
      end
    end

    context "save activity" do
      it "saves the activity" do
        expect { activity.save }.to change { db[model.to_sym].count }.by(1)
      end

      it "sets the hashed index" do
        activity.save.hashed_index.should_not be_nil
      end
    end

    context "update activity" do
      let(:updated_activity_date) { created_at + 2 }
      let(:updated_activity) do
        Model.clone_model_object(activity).tap do |a|
          a.status = "done"
          a.current_from = updated_activity_date 
        end
      end
      
      before do
        activity.save
      end

      it "updates the current_to of the previous activity" do
        updated_activity.save
        db[model.to_sym].where(:internal_id => activity.internal_id).first[:current_to].to_s.should == updated_activity_date.to_s
      end
    end

    context "duplicate activity" do
      it "raises an error" do
        expect do
          activity.save
          activity.save
        end.to raise_error(Sequel::HookFailed)
      end
    end
  end
end
