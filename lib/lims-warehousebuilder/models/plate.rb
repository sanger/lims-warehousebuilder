require 'lims-warehousebuilder/models/common'
require 'lims-warehousebuilder/resource_tools'

module Lims::WarehouseBuilder
  module Model
    class Plate < Sequel::Model(DB[:historic_plates])
      
      include ResourceTools::Mapping
      include Common

      def self.plate_by_uuid(uuid)
        Model.model_by_uuid(uuid, "plate")
      end
    end
  end
end
