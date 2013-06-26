require 'lims-warehousebuilder/models/common'

module Lims::WarehouseBuilder
  module Model
    class Item < Sequel::Model(:historic_items)

      include ResourceTools::Mapping
      # TODO: trigger in before_save to update items current table
      # Handle only one row per item uuid. Need to be fixed if a resource
      # appears in more than one order.
      include Common

      def before_create
        set_order_id!
      end

      def set_order_uuid(order_uuid)
        @order_uuid = order_uuid
      end

      def self.item_by_uuid(item_uuid)
        Model.model_for_uuid(item_uuid, "item")
      end

      private

      def set_order_id!
        order = Model.model_for_uuid(@order_uuid, "order")
        self.order_id = order.internal_id
      end
    end
  end
end
