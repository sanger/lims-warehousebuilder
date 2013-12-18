module Lims::WarehouseBuilder
  module Decoder
    module ContainerResourceShared
      private

      def _call(options)
        resource_uuid = @payload["uuid"]
        transfers = get_transfers

        if transfers && resource_uuids(transfers).include?(resource_uuid)
          # Set the force_save token to force the update of the resource
          force_save!
        end

        super
      end

      # Gets the uuids of the resources from the transfer array
      # @param [Array] transfer the array of transfer elements
      # @return [Array] uuids of the resources from the transfer array's elements
      def resource_uuids(transfers)
        transfers.inject([]) do |uuids, transfer|
          uuids << transfer["source_uuid"]
          uuids << transfer["target_uuid"]
          uuids
        end.uniq
      end

    end
  end
end
