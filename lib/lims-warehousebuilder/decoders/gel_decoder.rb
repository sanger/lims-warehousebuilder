require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder
  module Decoder
    class GelDecoder < JsonDecoder
      
      private

      def _call(options)
        gel = super
        [gel, gel_image]
      end

      def gel_image
        image = seek(@payload, :out_of_bounds__image)
        gel_uuid = @payload["uuid"]

        if image 
          # If the gel image already exists for the gel uuid,
          # we get back the record using prepared_model method
          # in order to update it (no history of images).
          gel_image_metadata_object = prepared_model(gel_uuid, "gel_image_metadata").tap do |gim|
            gim.created_at = @payload["date"]  
            gim.uuid = gel_uuid
          end

          gel_image_object = (gel_image_metadata_object.gel_image || Model::GelImage.new).tap do |gi|
            gi.image = image
          end

          gel_image_metadata_object.set_gel_image(gel_image_object)

          [gel_image_object, gel_image_metadata_object]
        end
      end
    end
  end
end
