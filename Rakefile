task :default => ["dev:run"]

namespace :dev do
  task :setup_env do
    ENV["LIMS_WAREHOUSEBUILDER_ENV"] = "development"
  end

  task :run => :setup_env do
    sh "bundle exec ruby script/start_warehousebuilder.rb"
  end

  task :migrate => :setup_env do 
    sh "bundle exec sequel -m db/migrations/ -e warehouse_development config/database.yml"
    sh "bundle exec sequel -m db/migrations_images/ -e warehouse_images_development config/database.yml"
  end

  task :migrate_down => :setup_env do 
    sh "bundle exec sequel -m db/migrations/ -M 0 -e warehouse_development config/database.yml"
    sh "bundle exec sequel -m db/migrations_images/ -M 0 -e warehouse_images_development config/database.yml"
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
    sh 'mysql -uroot -p -e "DROP DATABASE IF EXISTS warehouse_test; CREATE DATABASE warehouse_test DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"'
    sh 'mysql -uroot -p -e "DROP DATABASE IF EXISTS warehouse_images_test; CREATE DATABASE warehouse_images_test DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"'
    sh "bundle exec sequel -m db/migrations/ -e warehouse_test config/database.yml"
    sh "bundle exec sequel -m db/migrations_images/ -e warehouse_images_test config/database.yml"
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
    sh "bundle exec sequel -m db/migrations/ -e warehouse_production config/database.yml"
    sh "bundle exec sequel -m db/migrations_images/ -e warehouse_images_production config/database.yml"
  end

  task :run => :setup_env do
    sh "bundle exec ruby script/start_warehousebuilder.rb"
  end
end

