# frozen_string_literal: true

FactoryBot.define do
  factory :address, class: Hash do
    uuid { 'ewefrgweg3rethg34rty' }
    attn { 'Bob' }
    street { 'Something Street' }
    borough { 'Islington' }
    postcode { 'N12RH' }

    skip_create
    initialize_with { attributes }
  end
end
