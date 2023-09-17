require 'csv'

class Report
  def initialize(db)
    @db = db
  end

  # Write the Virs report containing organizations with the largest number of failed inspections
  def write
    data = collect
    header = %w[org_name tot_v failed_v]
    CSV.open('out/virs_report.tsv', 'w', col_sep: '\t') do |csv|
      csv << header
      csv << data.slice(:name, :vehicle_count, :failed).map(&:values)
    end
  end

  def print
    puts collect
  end

  # collect the Virs report containing organizations with the largest number of failed inspections.
  def collect
    report_sql = <<~SQL
      SELECT *,
             ((CAST(failed AS FLOAT) / vehicle_count) * 100.0) AS failed_percentage
      FROM
        (SELECT organizations.organization_id,
                organizations.name,
                COUNT(vehicles.vehicle_id) AS vehicle_count,
                SUM(CASE inspections.passed
                        WHEN false THEN 1
                        ELSE 0
                    END) AS failed
         FROM organizations
         JOIN inspections,
              vehicles ON organizations.organization_id = inspections.organization_id
         AND vehicles.vehicle_id = inspections.vehicle_id
         GROUP BY organizations.organization_id)
      ORDER BY failed_percentage DESC
      LIMIT 3
    SQL

    @db.fetch(report_sql).map(&:to_h)
  end
end
