# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :people, force: true do |t|
    t.string :uuid
    t.string :first_name
    t.string :middle_name
    t.string :last_name
    t.integer :version
    t.timestamps
  end
end
