require 'lims-warehousebuilder/json_decoder'
require 'rubygems'
require 'ruby-debug/debugger'

module Lims::WarehouseBuilder
  module Decoder
    class OrderDecoder < JsonDecoder

      private

      def _call(options)
        order = super
        [order, sample_management_activity]
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
                samples_info.each do |sample_info|
                  activity = klass.new({
                    :uuid => sample_info[:sample_uuid],
                    :process => process,
                    :step => role,
                    :user => user,
                    :date => date,
                    :status => status,
                    :is_current => 1
                  })
                  activity.set_sample_id!(sample_info[:sample_uuid])
                  activity.set_sample_container_id!(sample_info[:container_uuid], sample_info[:container_model])
                  activity.set_order_uuid(order_uuid)
                  activities << activity 
                end
              rescue Model::NotFound, Model::DBSchemaError => e
                raise MessageToBeRequeue.new(e.message)
              end
            end
          end
        end
      end
    end
  end
end
