require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder
  module Decoder
    class OrderDecoder < JsonDecoder

      private

      def _call(options)
        order = super
        [order, items, sample_management_activity]
      end

      
      def items
        klass = Model.model_for("item")
        order_uuid = @payload["uuid"]
        date = @payload["date"]
        user = @payload["user"]

        [].tap do |items|
          @payload["items"].each do |role, items_array|
            items_array.each do |item|
              item_uuid = item["uuid"]
              status = item["status"]
              batch_uuid = item["batch"]["uuid"] if item["batch"]

              item = prepared_model(item_uuid, "item").tap do |i|
                i.uuid = item_uuid
                i.order_uuid = order_uuid
                i.role = role
                i.batch_uuid = batch_uuid
                i.status = status
                i.created_at = date
                i.created_by = user
              end
              items << item
            end
          end
        end
      end


      # @return [Array<Model::SampleManagementActivity>]
      def sample_management_activity
        klass = Model.model_for("sample_management_activity")
        order_uuid = @payload["uuid"]
        process = @payload["pipeline"]
        date = @payload["date"]
        user = @payload["user"]

        [].tap do |activities|
          @payload["items"].each do |role, items_array|
            items_array.each do |item|
              item_uuid = item["uuid"]
              status = item["status"]

              begin
                samples_info = SampleContainerHelper.samples_info_by_item_uuid(item_uuid)
                unless samples_info.empty?
                  samples_info.each do |sample_info|
                    activity = klass.new({
                      :uuid => sample_info[:sample_uuid],
                      :order_uuid => order_uuid,
                      :process => process,
                      :step => role,
                      :user => user,
                      :current_from => date,
                      :status => status
                    })
                    activity.set_sample_container_uuid!(sample_info[:container_uuid], sample_info[:container_model])
                    activities << activity 
                  end
                end
              rescue Model::DBSchemaError, Model::NotFound => e
                raise MessageToBeRequeued.new(e.message)
              end
            end
          end
        end
      end
    end
  end
end
