# frozen_string_literal: true

FactoryBot.define do
  factory :admin, class: 'Admin' do
    name { Faker::Name.name }
    is_deleted { false }
  end
end
