require 'lims-warehousebuilder/models/common'

module Lims::WarehouseBuilder
  module Model
    class GelImage < Sequel::Model(DB_IMAGES[:gel_images])
      include Common

      one_to_one :gel_image_metadata

      # @param [String] uuid
      # @return [Model::GelImage]
      def self.gel_image_by_uuid(uuid)
        Model.model_by_uuid(uuid, :gel_image) 
      end
    end
  end
end
