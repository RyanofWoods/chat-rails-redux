require 'faker'

FactoryBot.define do
  factory :channel do
    name { Faker::Lorem.characters(number: 8) }

    factory :owned_channel do
      owner { association :user }
    end
  end
end
