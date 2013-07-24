require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder
  module Decoder
    class TubeDecoder < JsonDecoder

      private

      def _call(options)
        if @payload["ancestor_type"] == "tube_rack"
          tube_in_a_rack
        else
          super
        end
      end

      # Get the tubes in the tube rack, updated with
      # the tube rack information (location, tube_rack_uuid).
      # We do not save again the tubes which appear in the
      # tube rack payload but which are already saved with the
      # same information (happens after a tube rack update for example).
      # @see JsonDecoder#map_attributes_to_model
      # @return [Array]
      def tube_in_a_rack
        tube_rack_uuid = @payload["ancestor_uuid"]
        location = @payload["location"]
        date = @payload["date"] 
        user = @payload["user"]

        begin
          tube_model = prepared_model(@payload["uuid"], "tube") 
          tube_payload = @payload.merge({
            "location" => location,
            "tube_rack_uuid" => tube_rack_uuid,
            "date" => date,
            "user" => user
          })
          return map_attributes_to_model(tube_model, tube_payload)
        rescue Model::NotFound => e
          raise MessageToBeRequeued.new(e.message)
        end
      end
    end
  end
end
