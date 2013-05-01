unless defined?(DB)
  DB = Sequel.connect(YAML.load_file(File.join('config', 'database.yml'))[ENV["LIMS_WAREHOUSEBUILDER_ENV"]])
end

Sequel.default_timezone = :utc
