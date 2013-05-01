require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder
  module Decoder
    class SampleDecoder < JsonDecoder

      private

      # The SampleDecoder returns both Sample model
      # and SampleManagementActivity model.
      def _call
        sample = super
        [sample, sample_container_association, sample_management_activity]
      end

      # @return [Sequel::Model]
      def sample_container_association
        Model::SampleContainerHelper.new({
          :sample_uuid => @payload["uuid"],
          :container_uuid => @payload["ancestor_uuid"]
        })
      end

      # @return [Sequel::Model]
      # Initialize the row in the table sample_management_activity
      # for the sample, if it doesn't exist yet.
      def sample_management_activity
        sample_uuid = @payload["uuid"]
        klass = model_for("sample_management_activity")
        klass.activity_for_sample?(sample_uuid) ? nil : klass.new(:uuid => sample_uuid)
      end
    end
  end
end

