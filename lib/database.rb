# frozen_string_literal: true

require 'sequel'

class Database
  def initialize(db)
    @db = db
  end

  def create
    @db.create_table :inspections do
      foreign_key :vehicle_id, :vehicles
      foreign_key :organization_id, :organizations
      Date :date
      primary_key %i[vehicle_id date]
      Integer :period_id
      TrueClass :passed, null: true
    end

    @db.create_table :vehicles do
      primary_key :vehicle_id
      foreign_key :organization_id, :organizations
    end

    @db.create_table :organizations do
      primary_key :organization_id
      String :name
    end
  end

  def drop
    @db.drop_table(:inspections)
    @db.drop_table(:vehicles)
    @db.drop_table(:organizations)
  end
end
