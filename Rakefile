task :default => ["dev:run"]

namespace :dev do
  task :setup_env do
    ENV["LIMS_WAREHOUSEBUILDER_ENV"] = "development"
  end

  task :run => :setup_env do
    sh "bundle exec ruby script/start_warehousebuilder.rb"
  end

  task :migrate => :setup_env do 
    sh "bundle exec sequel -m db/migrations/ -e development config/database.yml"
  end

  task :migrate_down => :setup_env do 
    sh "bundle exec sequel -m db/migrations/ -M 0 -e development config/database.yml"
  end


  task :time => :setup_env do
    sh "time bundle exec ruby script/start_warehousebuilder.rb"
  end
end


namespace :test do
  task :setup_env do
    ENV["LIMS_WAREHOUSEBUILDER_ENV"] = "test"
  end

  task :migrate => :setup_env do 
    sh "bundle exec sequel -m db/migrations/ -e test config/database.yml"
  end

  task :spec => :setup_env do
    sh "bundle exec rspec spec/"
  end
end


namespace :prod do
  task :setup_env do
    ENV["LIMS_WAREHOUSEBUILDER_ENV"] = "production"
  end

  task :migrate => :setup_env do
    sh "bundle exec sequel -m db/migrations/ -e production config/database.yml"
  end

  task :run => :setup_env do
    sh "bundle exec ruby script/start_warehousebuilder.rb"
  end
end

