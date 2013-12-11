unless defined?(DB)
  env = ENV["LIMS_WAREHOUSEBUILDER_ENV"]
  db_settings = YAML.load_file(File.join('config', 'database.yml'))
  DB = Sequel.connect(db_settings[env])
end

Sequel.default_timezone = :utc
