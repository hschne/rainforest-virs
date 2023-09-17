require 'spec_helper'
require 'pry'

require_relative '../lib/report'

describe Report do
  context 'inspection' do
    let!(:vehicles) do
      10.times { Vehicle.create }
    end

    let!(:organizations) do
      Organization.create(name: 'first')
      Organization.create(name: 'second')
      Organization.create(name: 'third')
      Organization.create(name: 'fourth')
    end

    let!(:inspections) do
      # Create inspections
      # Org1 has 30% failed inspections and three vehicles
      # Org2 has 50% failed inspections and two vehicles
      # Org3 has 100% failed inspections and one vehicle
      Inspection.unrestrict_primary_key
      Inspection.create(organization_id: 1, vehicle_id: 1, passed: false, date: DateTime.now)
      Inspection.create(organization_id: 1, vehicle_id: 2, passed: true, date: DateTime.now)
      Inspection.create(organization_id: 1, vehicle_id: 3, passed: true, date: DateTime.now)
      Inspection.create(organization_id: 2, vehicle_id: 4, passed: false, date: DateTime.now)
      Inspection.create(organization_id: 2, vehicle_id: 5, passed: true, date: DateTime.now)
      Inspection.create(organization_id: 3, vehicle_id: 6, passed: false, date: DateTime.now)
      Inspection.create(organization_id: 4, vehicle_id: 7, passed: true, date: DateTime.now)
      Inspection.create(organization_id: 4, vehicle_id: 8, passed: true, date: DateTime.now)
      Inspection.create(organization_id: 4, vehicle_id: 9, passed: true, date: DateTime.now)
      Inspection.create(organization_id: 4, vehicle_id: 10, passed: true, date: DateTime.now)
    end

    it 'should collect data' do
      data = described_class.new(DB).collect

      expect(data.first[:name]).to eq('third')
      expect(data.first[:vehicle_count]).to eq(1)
      expect(data.first[:failed_percentage]).to eq(100.0)

      expect(data[1][:name]).to eq('second')
      expect(data[1][:vehicle_count]).to eq(2)
      expect(data[1][:failed_percentage]).to eq(50.0)

      expect(data[2][:name]).to eq('first')
      expect(data[2][:vehicle_count]).to eq(3)
      expect(data[2][:failed_percentage].round(1)).to eq(33.3)
    end
  end
end
