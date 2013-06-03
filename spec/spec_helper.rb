ENV["LIMS_WAREHOUSEBUILDER_ENV"] = "test" unless defined?(ENV["LIMS_WAREHOUSEBUILDER_ENV"])
require 'yaml'

def connect_db(env)
  config = YAML.load_file(File.join('config', 'database.yml'))
  Sequel.connect(config[env.to_s])
end

shared_context 'use database' do
  let(:db) { connect_db(:test) }

  after(:each) do
    db.tables.each { |table| db[table.to_sym].delete }
    db.disconnect
  end
end

