require 'sequel'
require_relative '../lib/database'
DB = Sequel.sqlite
Database.new(DB).create

RSpec.configure do |config|
  config.color = true
  config.around(:each) do |example|
    DB.transaction(rollback: :always, auto_savepoint: true) { example.run }
  end
end
