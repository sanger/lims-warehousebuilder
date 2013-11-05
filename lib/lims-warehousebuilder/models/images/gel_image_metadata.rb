require 'lims-warehousebuilder/models/common'

module Lims::WarehouseBuilder
  module Model
    class GelImageMetadata < Sequel::Model(DB_IMAGES[:gel_image_metadata])
      include Common
      many_to_one :gel_image

      # According to the way Sequel works, we need to
      # save first the gel image to get the primary key
      # to make the association. We set the association 
      # with GelImage before saving GelImageMetadata.
      def before_save
        self.gel_image = @gel_image
      end

      # @param [Model::GelImage] gel_image
      def set_gel_image(gel_image)
        @gel_image = gel_image
      end
    end
  end
end
