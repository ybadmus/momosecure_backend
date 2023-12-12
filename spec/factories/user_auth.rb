# frozen_string_literal: true

FactoryBot.define do
  factory :user_auth, class: 'UserAuth' do
    user { nil }
    login_type { :sms }
    sequence(:phone) { |i| "+23355#{i}027333" }
    sequence(:email) { |i| "user#{i}@momosecure.co" }
    auth_token { 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMTAifQ.qFu29fZipz7Ie-WpEkd0at0d-bxpsbb0MWaw4ZVgkYU' }

    trait :customer do
      user { association :customer }
    end

    trait :admin do
      user { association :admin }
    end
  end
end
