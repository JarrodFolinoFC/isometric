FactoryBot.define do
  factory :person, class: Hash do
    uuid { 'ewefrgweg3rethg34rty' }
    first_name { 'Bob' }
    middle_name { 'James' }
    last_name { 'Smith' }

    skip_create
    initialize_with { attributes }
  end
end