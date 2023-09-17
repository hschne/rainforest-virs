require 'bundler/setup'

require_relative 'lib/database'
DB = Sequel.connect('sqlite://development.db')

namespace :db do
  task :create do
    Database.new(DB).create
  end

  task :import do
    require_relative 'lib/import'
    Import.new(DB).import_all
  end

  task :drop do
    Database.new(DB).drop
  end
end

namespace :app do
  task :stats do
    App.new(DB).stats
  end
end

require 'rspec/core/rake_task'
rspec = RSpec::Core::RakeTask.new(:spec)
rspec.verbose = false

task default: :spec
