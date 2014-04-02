require 'digest'

module Lims::WarehouseBuilder
  module Model
    class SampleManagementActivity < Sequel::Model(DB[:sample_management_activity])

      def before_save
        super
        set_hashed_index!
        return false if has_duplicate?
        set_previous_activity_current_to!
      end

      # @param [String] container_uuid
      # @param [String] modelname
      def set_sample_container_uuid!(container_uuid, modelname)
        container_field = "#{modelname}_uuid="
        if self.respond_to?(container_field)
          self.send("#{modelname}_uuid=", container_uuid)
        else
          raise DBSchemaError, "#{container_field} column cannot be found in sample_management_activity table"
        end
      end

      private
  
      # Set the date in current_to column for
      # the last activity of the sample given
      # a particular step. The date an activity
      # stops to be current is the date the next
      # activity starts to be current.
      def set_previous_activity_current_to!
        self.class.dataset.where({
          :uuid => uuid,
          :order_uuid => order_uuid,
          :step => step,
          :current_to => nil
        }).update(:current_to => current_from)
      end

      # Compute a unique representation of the activity and store
      # it in hashed_index. The hash is computed from uuid, order_uuid,
      # process, step, status, resource_uuid (either tube_uuid or spin_column_uuid)
      # and the resource_type (either tube or spin_column)
      # TODO: make resource_id and resource_type generic. What if a new labware column is added?
      # need to update this method...
      # Also, if another activity instance has the same hashed_index, we can assume
      # it represents the same activity.
      def set_hashed_index!
        resource_uuid = tube_uuid ? tube_uuid : spin_column_uuid
        resource_type = tube_uuid ? "tube" : "spin_column"
        value = [uuid, order_uuid, process, step, status, resource_uuid, resource_type].join
        self.hashed_index = Digest::MD5.hexdigest(value)
      end

      # @return [Bool]
      # Return true if the current model is already 
      # stored in the database. 
      # Hashed_index column is indexed.
      def has_duplicate?
        self.class.dataset.where(:hashed_index => self.hashed_index).count > 0
      end
    end
  end
end
