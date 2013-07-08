require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder
  module Decoder
    class TubeRackDecoder < JsonDecoder

      private

      def _call(options)
        [].tap do |objects|
          # Set the force_save token to force the update of the 
          # tube rack even if none of its parameters has been changed.
          # (for update_tube_rack message)
          force_save! 
          tube_rack = super
          objects << tube_rack
          objects << updated_tubes
        end
      end

      # Get the tubes in the tube rack, updated with
      # the tube rack information (location, tube_rack_id).
      # We do not save again the tubes which appear in the
      # tube rack payload but which are already saved with the
      # same information (happens after a tube rack update for example).
      # @return [Array]
      def updated_tubes
        tube_rack_uuid = @payload["uuid"]
        tube_rack_id = Model.model_for_uuid(tube_rack_uuid, "tube_rack").internal_id rescue nil
        date = @payload["date"] 
        user = @payload["user"]

        [].tap do |tubes|
          @payload["tubes"].each do |location, tube|
            begin
              tube_model = prepared_model(tube["uuid"], "tube") 
              tube_model.set_tube_rack_uuid(tube_rack_uuid) unless tube_rack_id
              tube_payload = tube.merge({
                "location" => location,
                "tube_rack_id" => tube_rack_id,
                "date" => date,
                "user" => user
              })
              tubes << map_attributes_to_model(tube_model, tube_payload)
            rescue Model::NotFound => e
              raise MessageToBeRequeued.new(e.message)
            end
          end
        end
      end
    end
  end
end
