require 'faker'

FactoryBot.define do
  factory :channel do
    name { Faker::Lorem.characters(number: 10) }
  end
end