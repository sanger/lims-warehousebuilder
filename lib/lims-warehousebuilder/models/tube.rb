module Lims::WarehouseBuilder
  module Model
    class Tube < Sequel::Model(:historic_tubes)
      include ResourceTools::Mapping
      include Common

      def before_save
        super
        set_tube_rack_id! if @tube_rack_uuid
      end

      # @param [String] tube_uuid
      # @return [Sequel::Model]
      def self.tube_by_uuid(tube_uuid)
        Model.model_for_uuid(tube_uuid, "tube") 
      end

      # @param [String] uuid
      def set_tube_rack_uuid(uuid)
        @tube_rack_uuid = uuid
      end

      private

      # Note: Tube rack id is always set according to 
      # the current_tube_rack table. In that table, the 
      # internal_id of a tube_rack NEVER changes (@see triggers) on
      # historic_tube_racks table update (because the activity
      # table references it!). So the internal_id which is used
      # is the first internal_id of the tube rack added in the
      # historic_tube_racks table.
      def set_tube_rack_id!
        tube_rack = Model.model_for_uuid(@tube_rack_uuid, "tube_rack")
        self.tube_rack_id = tube_rack.internal_id
      end
    end
  end
end
