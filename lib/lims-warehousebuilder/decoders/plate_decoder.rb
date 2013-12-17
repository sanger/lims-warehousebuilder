require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder
  module Decoder
    class PlateDecoder < JsonDecoder

      private

      def _call(options)
        plate_uuid = @payload["uuid"]
        transfers = get_transfers

        if transfers && resource_uuids(transfers).include?(plate_uuid)
          [].tap do |objects|
            # Set the force_save token to force the update of the plate
            force_save!
            objects << super
          end
        else
          super
        end
      end

      def resource_uuids(transfers)
        uuids = []
        transfers.each do |transfer|
          uuids.merge!(transfer.map do |key, value|
            value if key.match(/uuid/)
          end)
        end
        uuids.compact
      end

    end
  end
end