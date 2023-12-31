# frozen_string_literal: true

FactoryBot.define do
  factory :payment, class: 'Payment' do
    amount { 1000 }
    status { 1 }
    commission { 1.0 }
    commission_fee { 10 }
    reference_number { Faker::Alphanumeric.alphanumeric(number: 50) }
    sender_user_auth { association :user_auth }
    receiver_user_auth { association :user_auth }
    is_deleted { false }
    expired_at { nil }
  end
end
