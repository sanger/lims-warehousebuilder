require 'lims-busclient'
require 'lims-warehousebuilder/json_decoder'
require 'lims-warehousebuilder/table_migration'

module Lims
  module WarehouseBuilder

    MessageToBeRequeued = Class.new(StandardError)
    ProcessingFailed = Class.new(StandardError)

    class Builder
      include Lims::BusClient::Consumer
      include TableMigration

      attribute :queue_name, String, :required => true, :writer => :private
      attribute :log, Object, :required => false, :writer => :private
      
      # @param [Hash] amqp_settings
      def initialize(amqp_settings, message_settings)
        @queue_name = amqp_settings.delete("queue_name")
        @not_supported_actions = message_settings["not_supported_actions"] ? message_settings["not_supported_actions"] : {}
        consumer_setup(amqp_settings)
        set_queue
      end

      # @param [Logger] logger
      def set_logger(logger)
        @log = logger
      end

      private

      # Setup the queue
      # For each message we received, we process all the 
      # s2 resource it contains in the foreach_s2_resource loop.
      # For each s2 resource, we get the right decoder. Decoding
      # the resource gives back an instance of a Sequel model, ready 
      # to be saved in the warehouse.
      def set_queue
        self.add_queue(queue_name) do |metadata, payload|
          log.info("Message received with the routing key: #{metadata.routing_key}")
          log.debug("Processing message with routing key: '#{metadata.routing_key}' and payload: #{payload}")
          begin
            action = metadata.routing_key.match(/^[\w\.]*\.(\w*)$/)[1]
            unless (@not_supported_actions.include?(action))
              objects = decode_payload(payload, action)
              maintain_warehouse(objects)
              save_all(objects)
              metadata.ack
              log.info("Message processed and acknowledged")
            else
              metadata.reject(:requeue => false)
              log.info("The action '#{action}' that the message contained is unsupported. The message has been rejected.")
            end
          rescue Sequel::Rollback, MessageToBeRequeued => e
            metadata.reject(:requeue => true)
            log.info("Message requeued: #{e}")
          rescue ProcessingFailed => ex
            # TODO: use the dead lettering queue
            metadata.reject
            log.error("Processing the message '#{metadata.routing_key}' failed with: #{ex.to_s}")
          rescue StandardError => ste
            log.error("Processing the message '#{metadata.routing_key}' failed with: #{ste.to_s}")
            log.error("The failed payload of the message:")
            log.error(payload)
            raise ste
          end
        end
      end

      # @param [Hash] payload
      # @param [String] action
      # @return [Array<Sequel::Model>]
      def decode_payload(payload, action)
        [].tap do |objects_to_save|
          Decoder::JsonDecoder.foreach_s2_resource(payload) do |model, attributes|
            decoder = decoder_for(model).new(model, attributes, payload)
            objects = decoder.call({:action => action})
            objects_to_save << objects
          end
        end.flatten
      end

      # @param [String] name
      # @return [JsonDecoder]
      def decoder_for(name)
        Decoder::JsonDecoder.decoder_for(name)
      end

      # @param [Array] objects
      def save_all(objects)
        DB.transaction(:rollback => :reraise) do
          objects.each do |o|
            begin
              next unless o
              o.save
            rescue Sequel::HookFailed => e
              # if the model's before_save method fails
              log.error("Exception raised: #{e}")
            end
          end
        end
      end

      # @param [Array<Sequel::Model>] objects
      # Setup the triggers in the warehouse for each model involved
      def maintain_warehouse(objects)
        {}.tap do |tables|
          objects.each do |o|
            klass = o.class
            next unless ResourceTools::Database::HISTORIC_TABLES.include?(klass.table_name.to_s)
            tables[klass.table_name] = klass.columns
          end
        end.each do |table_name, columns|
          maintain_warehouse_for(table_name, columns)
        end
      end
    end
  end
end
