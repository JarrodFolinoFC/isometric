# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :addresses, force: true do |t|
    t.string :uuid
    t.string :attn
    t.string :street
    t.string :borough
    t.string :postcode
    t.integer :version
    t.timestamps
  end
end
