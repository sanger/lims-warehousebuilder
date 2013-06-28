require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder
  module Decoder
    class SampleDecoder < JsonDecoder

      private

      # The SampleDecoder returns both Sample model
      # and SampleManagementActivity model.
      def _call(options)
        [].tap do |objects|
          if @payload["ancestor_uuid"]
            # Sample which are part from other laboratory asset like tubes...
            objects << sample_container_association
            objects << sample_management_activity
          else
            # Sample object from lims-management-app. Are not part
            # of other s2 resource so they don't have an ancestor_uuid.
            if options[:action] =~ /delete/
              objects << prepared_model(@payload["uuid"], @model).tap do |sample|
                sample.deleted_at = @payload["date"]
                sample.deleted_by = @payload["user"]
              end
            else
              objects << super unless @payload["ancestor_uuid"]
            end
          end
        end
      end

      # This method saves the sample activity for each sample
      # found in a s2_resource. It succeeds if for the sample,
      # we can find an item associated to its container uuid,
      # a sample row and an order associated with its container.
      # If not, we just skip, and the sample activity could be
      # handled in the order_decoder.
      # @return [Sequel::SampleManagementActivity,Nil]
      def sample_management_activity
        sample_uuid = @payload["uuid"]
        container_uuid = @payload["ancestor_uuid"]
        container_type = @payload["ancestor_type"]
        user = @payload["user"]
        date = @payload["date"]

        begin
          item = Model::Item.item_by_uuid(container_uuid) 
          sample = Model::Sample.sample_by_uuid(sample_uuid)
          order = Model::Order.order_by_id(item.order_id)

          activity = Model::SampleManagementActivity.new({
            :sample_id => sample.internal_id,
            :order_id => item.order_id,
            :uuid => sample_uuid,
            :process => order.pipeline,
            :step => item.role,
            :user => user,
            :current_from => date,
            :status => item.status
          })
          activity.set_sample_container_id!(container_uuid, container_type)
          activity
          # We do not requeue the message if a notfound exception is raised.
          # The sample activity could be managed by the order_decoder in that case.
        rescue Model::NotFound => e
        rescue Model::DBSchemaError => e
          raise MessageToBeRequeued.new(e.message)
        end
      end

      # @return [Sequel::Model]
      def sample_container_association
        Model::SampleContainerHelper.new({
          :sample_uuid => @payload["uuid"],
          :container_uuid => @payload["ancestor_uuid"],
          :container_model => @payload["ancestor_type"]
        })
      end
    end
  end
end

