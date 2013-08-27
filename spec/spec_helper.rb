ENV["LIMS_WAREHOUSEBUILDER_ENV"] = "test" unless defined?(ENV["LIMS_WAREHOUSEBUILDER_ENV"])
require 'yaml'
require 'timecop'
require 'sequel'
require 'lims-warehousebuilder/table_migration'
require 'lims-warehousebuilder/model'

def connect_db(env)
  config = YAML.load_file(File.join('config', 'database.yml'))
  Sequel.connect(config[env.to_s])
end

# Triggers setup
DB.tables.select { |table| table =~ /historic/ }.each do |table|
  migration = Class.new { include Lims::WarehouseBuilder::TableMigration }.new
  migration.maintain_warehouse_for(table, DB[table.to_sym].columns)
end

shared_context 'use database' do
  let(:db) { connect_db(:test) }

  after(:each) do
    db[:sample_management_activity].delete
    db[:historic_tubes].delete
    db[:current_tubes].delete
    db.tables.each { |table| db[table.to_sym].delete }
    db.disconnect
  end
end

shared_context "timecop" do
  before do
    Timecop.freeze(Time.now.utc)
  end

  after do
    Timecop.return
  end
end
