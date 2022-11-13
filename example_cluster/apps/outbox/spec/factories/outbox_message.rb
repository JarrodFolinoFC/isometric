# frozen_string_literal: true

FactoryBot.define do
  factory :outbox_message, class: Hash do
    uuid { 'uuid1' }
    correlation_id { 'corr1' }
    queue { 'queue1' }
    model { 'Model' }
    app_id { 'app' }
    payload {
      {
        'data' => 'else'
      }
    }
    headers {
      {
        'something' => 'else'
      }
    }
    processed_at { nil }
    skip_create
    initialize_with { attributes }
  end
end
