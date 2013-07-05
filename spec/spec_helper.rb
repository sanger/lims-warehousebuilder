ENV["LIMS_WAREHOUSEBUILDER_ENV"] = "test" unless defined?(ENV["LIMS_WAREHOUSEBUILDER_ENV"])
require 'yaml'
require 'timecop'

def connect_db(env)
  config = YAML.load_file(File.join('config', 'database.yml'))
  Sequel.connect(config[env.to_s])
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
