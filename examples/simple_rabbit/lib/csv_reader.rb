# frozen_string_literal: true

require 'csv'
require 'json'

class CsvReader
  def self.parse_csv(file)
    data = []
    CSV.foreach(file, headers: true, col_sep: '|') do |row|
      data << {
        internal_id: row['internal_id'], name: row['name'],
        event_date: row['event_date'], venue: row['venue'],
        location: row['location']
      }
    end
    data.to_json
  end
end
