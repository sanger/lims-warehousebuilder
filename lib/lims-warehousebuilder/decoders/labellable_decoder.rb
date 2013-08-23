require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder
  module Decoder
    class LabellableDecoder < JsonDecoder

      private

      def _call(options)
        barcodes
      end

      def barcodes
        barcoded_resource_uuid = @payload["name"]
        date = @payload["date"]
        user = @payload["user"]
        klass = Model.model_for("barcode")
        tmp_barcodes = {}

        @payload["labels"].each do |position, label|
          label_value = label["value"]
          label_type = case label["type"]
                       when /sanger/ then "sanger"
                       when /ean13/ then "ean13"
                       end

          begin
            barcode = klass.send("barcode_by_#{label_type}_barcode", label_value)
          rescue Model::NotFound => e
            raise MessageToBeRequeued.new(e.message)
          end

          tmp_barcodes[barcode] ||= []
          tmp_barcodes[barcode] << {:type => label_type, :position => position}
        end

        [].tap do |barcodes|
          tmp_barcodes.each do |barcode, labels|
            new_barcode = Model.clone_model_object(barcode)
            labels.each do |label|
              new_barcode.barcoded_resource_uuid = barcoded_resource_uuid
              new_barcode.send("#{label[:type]}_barcode_position=", label[:position])
              new_barcode.updated_at = date
              new_barcode.updated_by = user
            end
            barcodes << new_barcode
          end
        end
      end
    end
  end
end
