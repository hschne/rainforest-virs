# frozen_string_literal: true

require 'csv'
require_relative 'inspection'
require_relative 'organization'
require_relative 'vehicle'
require 'pry'

class Import
  def initialize(db)
    @db = db
  end

  # Imports the data from the CSVs into the SQLite Db. Note that we store order fees at import time.
  def import_all
    files = Dir['data/*.csv']
    files.each do |file|
      csv = CSV.parse(File.read(file), col_sep: '|', headers: true)
      # Poor-mans symbolize_keys
      rows = csv.map(&:to_h).map { |hash| hash.transform_keys(&:to_sym) }
      import(rows)
    end
  end

  def import(rows)
    # As we are importing, we need to unrestrict to be able to explictly write primary keys. Otherwise, Sequel will throw
    # an error.
    Inspection.unrestrict_primary_key
    Organization.unrestrict_primary_key
    Vehicle.unrestrict_primary_key

    rows.each do |row|
      # If there are conflicts (e.g. a organization already exists) simply overwrite records, as that means that data simply
      # has changed.
      org_data = row.slice(:vehicle_org_id, :org_name).transform_keys(vehicle_org_id: :organization_id, org_name: :name)
      @db[:organizations]
        .insert_conflict(:replace)
        .insert(**org_data)

      vehicle_data = row.slice(:vehicle_id, :vehicle_org_id).transform_keys(vehicle_org_id: :organization_id)
      @db[:vehicles]
        .insert_conflict(:replace)
        .insert(**vehicle_data)
      inspection_data = row
                        .slice(:vehicle_id, :vehicle_org_id, :inspection_date, :inspection_period_id, :inspection_passed)
                        .transform_keys(
                          vehicle_org_id: :organization_id,
                          inspection_date: :date,
                          inspection_period_id: :period_id,
                          inspection_passed: :passed
                        )
      @db[:inspections]
        .insert_conflict(:replace)
        .insert(**inspection_data)
    end
  end
end
