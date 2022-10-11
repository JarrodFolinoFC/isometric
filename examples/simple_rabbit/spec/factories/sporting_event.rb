FactoryBot.define do
  factory :sporting_event, class: Hash do
    internal_id { 617 }
    name { 'UFC on ESPN: Vera vs. Cruz' }
    event_date { 'Aug 13, 2022' }
    venue { 'Pechanga Arena' }
    location { 'San Diego, California, U.S.' }

    skip_create
    initialize_with { attributes }
  end
end