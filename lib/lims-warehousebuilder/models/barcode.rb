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

    end
  end
end
