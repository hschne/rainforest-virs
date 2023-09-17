require 'sequel'

class Organization < Sequel::Model
  one_to_many :vehicles
  one_to_many :inspections
end
