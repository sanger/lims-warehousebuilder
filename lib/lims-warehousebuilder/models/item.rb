module Lims::WarehouseBuilder
  module Model
    class Item < Sequel::Model(:historic_items)

      include ResourceTools::Mapping
      include Common

      translate(:batch__uuid => :batch_uuid)
    end
  end
end
