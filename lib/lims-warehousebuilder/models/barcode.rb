require 'lims-warehousebuilder/models/common'

module Lims::WarehouseBuilder
  module Model
    class Barcode < Sequel::Model(:historic_barcodes)
      
      include ResourceTools::Mapping
      include Common

      translate({
        :ean13 => :ean13_barcode,
        [:sanger__prefix, :sanger__number, :sanger__suffix] => :sanger_barcode
      })

      def self.barcode_by_sanger_barcode(value)
        self.dataset.from(current_table_name).where(:sanger_barcode => value).first
      end

      def self.barcode_by_ean13_barcode(value)
        self.dataset.from(current_table_name).where(:ean13_barcode => value).first
      end
    end
  end
end
