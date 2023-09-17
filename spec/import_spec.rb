require 'spec_helper'
require 'pry'

require_relative '../lib/import'

describe Import do
  context 'inspection' do
    let(:data) do
      [{
        vehicle_id: 1,
        inspection_date: '2020-02-06',
        vehicle_org_id: 1,
        org_name: 'org',
        inspection_period_id: 123,
        inspection_passed: 'TRUE'
      }]
    end

    it 'should create org record' do
      Import.new(DB).import(data)

      expect(Organization.first.organization_id).to eq(data.first[:vehicle_org_id])
      expect(Organization.first.name).to eq(data.first[:org_name])
    end

    it 'should create vehicle record' do
      Import.new(DB).import(data)

      expect(Vehicle.first.vehicle_id).to eq(data.first[:vehicle_id])
    end

    it 'should create inspection record' do
      Import.new(DB).import(data)

      expect(Inspection.first.vehicle_id).to eq(data.first[:vehicle_id])
      expect(Inspection.first.organization_id).to eq(data.first[:vehicle_org_id])
      inspection_date = Date.parse(data.first[:inspection_date])
      expect(Inspection.first.date).to eq(inspection_date)
      expect(Inspection.first.period_id).to eq(data.first[:inspection_period_id])
      expect(Inspection.first.passed).to eq(true)
    end
  end

  context 'updating inspections' do
    let(:data) do
      [
        {
          vehicle_id: 1,
          inspection_date: '2020-02-06',
          vehicle_org_id: 1,
          org_name: 'org',
          inspection_period_id: 123,
          inspection_passed: nil
        },
        {
          vehicle_id: 1,
          inspection_date: '2020-02-06',
          vehicle_org_id: 1,
          org_name: 'changed',
          inspection_period_id: 123,
          inspection_passed: 'FALSE'
        },
        {
          vehicle_id: 1,
          inspection_date: '2020-02-07',
          vehicle_org_id: 2,
          org_name: 'new',
          inspection_period_id: 123,
          inspection_passed: 'TRUE'
        }
      ]
    end

    it 'should update organization name' do
      Import.new(DB).import(data)

      expect(Organization[1].name).to eq('changed')
    end

    it 'should update vehicle ownership' do
      Import.new(DB).import(data)

      expect(Vehicle[1].organization.organization_id).to eq(2)
    end

    it 'should update adjudicated result' do
      Import.new(DB).import(data)

      expect(Inspection.first.passed).to eq(false)
    end
  end
end
