require 'faker'

FactoryBot.define do
  factory :user do
    transient do
      admin { false }
    end

    username { Faker::Lorem.characters(number: 8) }
    email { Faker::Internet.unique.email }
    password { Faker::Lorem.characters(number: 10) }

    after(:create) do |user, evaluator|
      user&.admin_authority! if evaluator.admin
    end
  end
end
