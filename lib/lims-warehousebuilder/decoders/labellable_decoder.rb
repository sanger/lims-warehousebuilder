require 'lims-warehousebuilder/json_decoder'
require 'rubygems'
require 'ruby-debug/debugger'

module Lims::WarehouseBuilder
  module Decoder
    class LabellableDecoder < JsonDecoder

      private

      def _call(options)
        barcodes
      end

      def barcodes
        barcoded_resource_uuid = @payload["name"]
        klass = model_for("barcode")

        [].tap do |barcodes|
          @payload["labels"].each do |position, label|
            label_value = label["value"]
            barcode = case label["type"]
                      when /sanger/ then klass.barcode_by_sanger_barcode(label_value) 
                      when /ean13/ then klass.barcode_by_ean13_barcode(label_value)
                      end

            barcode.barcoded_resource_uuid = barcoded_resource_uuid
            barcode.position = position
            barcodes << barcode
          end
        end
      end
    end
  end
end
