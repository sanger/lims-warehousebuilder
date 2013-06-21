module Lims::WarehouseBuilder
  module Model
    class Order < Sequel::Model(:historic_orders)
      
      include ResourceTools::Mapping
      include Common

      def self.order_by_id(order_id)
        order = self.dataset.from(current_table_name).where(:internal_id => order_id).first
        raise NotFound, "The order with internal_id #{order_id} cannot be found" unless order
        order
      end
    end
  end
end
