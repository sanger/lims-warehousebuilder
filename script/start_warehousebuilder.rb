require 'yaml'
require 'lims-warehousebuilder'
require 'logging'
require 'lims-exception-notifier-app/exception_notifier'

module Lims
  module WarehouseBuilder
    env = ENV["LIMS_WAREHOUSEBUILDER_ENV"] or raise "LIMS_WAREHOUSEBUILDER_ENV is not set in the environment"

    amqp_settings = YAML.load_file(File.join('config','amqp.yml'))[env]
    warehouse_settings = YAML.load_file(File.join('config','database.yml'))[env]

    builder = Builder.new(amqp_settings, warehouse_settings)
    builder.set_logger(Logging::LOGGER)

    notifier = Lims::ExceptionNotifierApp::ExceptionNotifier.new

    Logging::LOGGER.info("Builder started")

    begin
      notifier.notify do
        builder.start
      end
    rescue StandardError, LoadError, SyntaxError => e
      # log the caught exception
      notifier.send_notification_email(e)
    end

    Logging::LOGGER.info("Builder stopped")
  end
end
