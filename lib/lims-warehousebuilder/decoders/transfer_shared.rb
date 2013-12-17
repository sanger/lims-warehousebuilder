module Lims::WarehouseBuilder
  module Decoder
    module TransferShared
      # @return [Array] the transfer array from the payload or nill
      # if the JSON does not contain it
      def get_transfers
        full_playload_hash = JsonDecoder::to_hash(@full_payload)
        action = full_playload_hash.keys[0]
        full_playload_hash[action]["transfers"]
      end
    end
  end
end
