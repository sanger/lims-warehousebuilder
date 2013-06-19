require 'lims-warehousebuilder/core_ext'

module Lims::WarehouseBuilder
  module Model
    class SampleManagementActivity < Sequel::Model(:sample_management_activity)

      def before_save
        set_order_id!
        return false if has_duplicate?
        update_is_current_flag
      end

      # @param [String] sample_uuid
      def set_sample_id!(sample_uuid)
        sample = Model.model_for_uuid(sample_uuid, "sample")
        self.sample_id = sample.internal_id
      end

      # @param [String] order_uuid
      # Order and Activity come from a same message. So the first
      # time an order message is received, we decode the order
      # and the corresponding activities, BUT the order is not yet
      # stored in the database. That's why the order_id is set 
      # in the before_save filter, once the order is previously 
      # saved (as it's returned in first position by OrderDecoder#_call).
      def set_order_uuid(order_uuid)
        @order_uuid = order_uuid
      end

      # @param [String] container_uuid
      # @param [String] modelname
      def set_sample_container_id!(container_uuid, modelname)
        container = Model.model_for_uuid(container_uuid, modelname)
        container_field = "#{modelname}_id="
        if self.respond_to?(container_field)
          self.send("#{modelname}_id=", container.internal_id)
        else
          raise DBSchemaError, "#{container_field} column cannot be found in sample_management_activity table"
        end
      end

      private

      def set_order_id!
        order = Model.model_for_uuid(@order_uuid, "order")
        self.order_id = order.internal_id
      end

      # Set is_current to 0 for all the rows 
      # which mention <sample_id> and <order_id>
      # TODO: do not update if the date in the database is more recent 
      # than the one in the message
      def update_is_current_flag
        self.class.dataset.where({
          :order_id => order_id, 
          :sample_id => sample_id
        }).update(:is_current => 0)
      end

      # @return [Bool]
      # Return true if the current model is already 
      # stored in the database. 
      # TODO: possible bottleneck here. There is a multi-columns
      # index on (sample_id, order_id, tube_id, spin_column_id).
      # Is it enough?
      def has_duplicate?
        self.class.dataset.where({
          :sample_id => sample_id,
          :order_id => order_id,
          :tube_id => tube_id,
          :spin_column_id => spin_column_id,
          :process => process,
          :step => step,
          :status => status
        }).count > 0
      end
    end
  end
end

