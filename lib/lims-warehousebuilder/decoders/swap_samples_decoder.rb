require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder
  module Decoder
    class SwapSamplesDecoder < JsonDecoder

      private

      SAMPLE_CONTAINER_TYPES = ["tube", "spin_column"]

      # 2 tables need to be updated after a swap samples action
      # The first one is the sample_container_helper table.
      # For each container mentionned in the swap samples action,
      # we need to change the sample uuids associated.
      # If the swap samples action is done at the tube rack action,
      # we need to get the first container of the sample (tubes).
      # The second table is the sample_management_activity table.
      # We need to add a new row for each new sample involved in a
      # container.
      def _call(options)
        [].tap do |objects|
          @payload["parameters"].each do |parameter|
            container_uuid = parameter["resource_uuid"]
            container_type = parent_key_for_uuid(container_uuid)
            swaps = parameter["swaps"]
            containers = [container_uuid]
            old_sample_uuids = swaps.inject([]) { |m,(k,v)| m << k } 

            unless SAMPLE_CONTAINER_TYPES.include?(container_type)
              model = Model.model_for(container_type) 
              if model.respond_to?(:children_uuids_for)
                containers = model.children_uuids_for(container_uuid) 
              else
                raise ProcessingFailed, "Undefined method 'children_uuids_for' for #{container_type} model"  
              end
            end

            helpers = updated_sample_container_helpers(containers, old_sample_uuids, swaps)
            objects << helpers

            helpers.each do |helper|
              objects << sample_management_activity(helper.sample_uuid, helper.container_uuid, helper.container_type)   
            end
          end
        end
      end

      # @param [Array] containers
      # @param [Array] sample_uuids
      # @return [Array]
      def updated_sample_container_helpers(containers, sample_uuids, swaps)
        [].tap do |updated_helpers|
          helpers = Model::SampleContainerHelper.helpers_by_container_and_sample_uuids(containers, sample_uuids)
          helpers.each do |helper|
            new_sample_uuid = swaps[helper.sample_uuid]
            updated_helpers << helper.tap { |h| h.sample_uuid = new_sample_uuid } if new_sample_uuid
          end
        end
      end

      # @param [String] sample_uuid
      # @param [String] container_uuid
      # @param [String] container_type
      # @return [Model::SampleManagementActivity]
      def sample_management_activity(sample_uuid, container_uuid, container_type)
        user = @payload["user"]
        date = @payload["date"]

        begin
          item = Model.model_by_uuid(container_uuid, "item")
          order = Model.model_by_uuid(item.order_uuid, "order")
          sample = Model::Sample.sample_by_uuid(sample_uuid)

          activity = Model::SampleManagementActivity.new({
            :uuid => sample_uuid,
            :order_uuid => order.uuid,
            :process => order.pipeline,
            :step => item.role,
            :user => user,
            :current_from => date,
            :status => item.status
          })
          activity.set_sample_container_uuid!(container_uuid, container_type)
          activity
        rescue Model::NotFound, Model::DBSchemaError => e
          raise MessageToBeRequeued.new(e.message)
        end
      end
    end
  end
end
