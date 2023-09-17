require 'sequel'

class Inspection < Sequel::Model
  many_to_one :vehicle
  many_to_one :organization
end
