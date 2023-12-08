FactoryBot.define do
  factory :admin, class: 'Admin' do
    name { 'Admin user' }
    is_deleted { false }
  end
end
