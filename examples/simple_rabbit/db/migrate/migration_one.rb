# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :sporting_events, force: true do |t|
    t.string :internal_id
    t.string :name
    t.datetime :event_date
    t.string :venue
    t.string :location

    t.integer :version
    t.string :uuid
    t.timestamps
  end
end
