# frozen_string_literal: true

FactoryBot.define do
  factory :dispute, class: 'Dispute' do
    name { Faker::Name.name }
    is_deleted { false }
    category
    contact_number
    description
    status
    payment { association :payment }
    user { association :user_auth }
  end
end
