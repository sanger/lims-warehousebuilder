require 'lims-warehousebuilder/json_decoder'
require 'lims-warehousebuilder/decoders/container_resource_shared'

module Lims::WarehouseBuilder
  module Decoder
    class PlateDecoder < JsonDecoder

      include ContainerResourceShared

    end
  end
end
