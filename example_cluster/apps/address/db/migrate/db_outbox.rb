# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :outbox_messages, force: true do |t|
    t.string :correlation_id
    t.string :queue
    t.string :model
    t.string :app_id
    t.binary :payload
    t.binary :headers
    t.datetime :published_at
    t.datetime :processed_at

    t.timestamps
  end

  create_table :outbox_acks, force: true do |t|
    t.belongs_to :outbox_message
    t.string :application_name
    t.binary :message
    t.timestamps
  end
end
