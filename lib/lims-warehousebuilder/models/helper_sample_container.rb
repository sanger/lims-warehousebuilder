module Lims::WarehouseBuilder
  module Model
    # The messages associated to order items only include the item 
    # uuid, its role and status. In this kind of message, we don't know
    # the sample associated with the item in the order. As a result,
    # every time a resource is created with a sample, we save the 
    # association sample_uuid resource_uuid in the table 
    # sample_container_helper. Then, when we receive an order message,
    # we can get the sample uuid from the item uuid using this table. 
    # And then, use the sample uuid to get back the right row in 
    # sample_management_activity table.
    class SampleContainerHelper < Sequel::Model(:sample_container_helper)
      
      def before_save
        self.class.where(values).count == 0
      end

      # @param [String] uuid
      # @return [Array<String>]
      def self.sample_uuids_by_container_uuid(uuid)
        row = self.where(:container_uuid => uuid).select(:sample_uuid).all
        unless row.empty?
          row.map { |r| r.sample_uuid }
        else
          raise NotFound, "no sample uuid found for container #{uuid}"
        end
      end

    end
  end
end

