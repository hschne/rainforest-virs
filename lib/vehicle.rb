require 'sequel'

class Vehicle < Sequel::Model
  many_to_one :organization
  one_to_many :inspections
end
