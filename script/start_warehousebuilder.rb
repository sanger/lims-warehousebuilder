require 'yaml'
require 'lims-warehousebuilder'
require 'logging'

module Lims
  module WarehouseBuilder
    env = ENV["LIMS_WAREHOUSEBUILDER_ENV"] or raise "LIMS_WAREHOUSEBUILDER_ENV is not set in the environment"

    amqp_settings = YAML.load_file(File.join('config','amqp.yml'))[env]
    warehouse_settings = YAML.load_file(File.join('config','database.yml'))[env]

    builder = Builder.new(amqp_settings, warehouse_settings)
    builder.set_logger(Logging::LOGGER)

    Logging::LOGGER.info("Builder started")
    builder.start
    Logging::LOGGER.info("Builder stopped")
  end
end

