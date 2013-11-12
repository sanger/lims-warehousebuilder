require 'lims-warehousebuilder/models/common'

module Lims::WarehouseBuilder
  module Model
    class GelImage < Sequel::Model(DB_IMAGES[:gel_images])
      include Common

      one_to_one :gel_image_metadata
    end
  end
end
