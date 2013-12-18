require 'lims-warehousebuilder/json_decoder'
require 'lims-warehousebuilder/decoders/transfer_shared'
require 'lims-warehousebuilder/decoders/container_resource_shared'

module Lims::WarehouseBuilder
  module Decoder
    class FluidigmDecoder < JsonDecoder

      include TransferShared
      include ContainerResourceShared

    end
  end
end
