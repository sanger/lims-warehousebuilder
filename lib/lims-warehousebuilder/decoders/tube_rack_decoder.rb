require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder
  module Decoder
    class TubeRackDecoder < JsonDecoder

      private

      def _call(options)
        [].tap do |objects|
         if options[:action] =~ /delete/ 
            objects << prepared_model(@payload["uuid"], @model).tap do |rack|
              rack.deleted_at = @payload["date"]
              rack.deleted_by = @payload["user"]
            end
          else
            # Set the force_save token to force the update of the 
            # tube rack even if none of its parameters has been changed.
            # (for update_tube_rack message)
            force_save! 
            objects << super
          end
        end
      end
    end
  end
end
