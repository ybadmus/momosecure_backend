# frozen_string_literal: true

FactoryBot.define do
  factory :comment, class: 'Comment' do
    commentable_type
    is_deleted { false }
    content { Faker::Lorem.paragraph }
    commentable_id
    user { association :user_auth }
  end
end
