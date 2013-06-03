require 'facets/kernel'
require 'sequel'
# A sequel connection is needed before loading all the models
require 'lims-warehousebuilder/sequel'
require 'lims-warehousebuilder/resource_tools'
require_all('models/*.rb')

module Lims::WarehouseBuilder
  module Model

    class NotFound < StandardError
    end

    class UnknownModel < StandardError
    end

    # @param [String] name
    # @return [Class]
    def model_for(name)
      lower_name = name.downcase
      alphanum_name = lower_name.gsub(/_/, "")
      return NameToSequel[alphanum_name] if NameToSequel[alphanum_name]

      plural_name = "#{lower_name}s"
      if ResourceTools::Database::MODEL_TABLES.include?(plural_name) ||
        ResourceTools::Database::MODEL_TABLES.include?(lower_name)
        return generate_model(lower_name)
      else
        raise UnknownModel, "unknown required model (#{lower_name})"
      end
    end

    # @param [String] uuid
    # @param [Nil, String] modelname
    # @return [Sequel::Model,Nil]
    # Lookup in the database for the model type corresponding 
    # to the uuid in parameter.
    def model_for_uuid(uuid, modelname)
      model = model_for(modelname)
      model.from(model.current_table_name).where(:uuid => uuid).first
    end

    # @param [String] uuid
    # @param [Nil,String] model_name
    # @return [Sequel::Model]
    # Return a prepared model to work with
    # If we can get an existing model from the payload uuid
    # we create a new model instance using the values of that 
    # existing model.
    def prepared_model(uuid, modelname)
      model = model_for_uuid(uuid, modelname)
      model ? model.class.new(model.values - [model.primary_key]) : model_for(modelname).new
    end

    # @param [Sequel::Model] object
    # @return [Sequel::Model]
    def clone_model_object(object)
      values = object.values.reject { |k,v| k == object.primary_key }
      object.class.new(values)
    end

    private

    def generate_model(name)
      class_name = name.capitalize.gsub(/_[^_]*/) { |b| b[1..b.size].capitalize }
      Model.class_eval %Q{
          class #{class_name} < Sequel::Model(:historic_#{name}s)
            include ResourceTools::Mapping
            include Common
          end
      }
      Model.const_get(class_name)
    end

    NameToSequel = {}.tap do |h|
      Lims::WarehouseBuilder::Model::constants.each do |module_name|
        mod = Lims::WarehouseBuilder::Model.const_get(module_name)
        next unless mod.is_a?(Module)
        h[module_name.to_s.downcase] = mod if mod.ancestors.include?(Sequel::Model)
      end
    end
  end
end
