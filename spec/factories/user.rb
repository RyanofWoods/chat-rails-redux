require 'faker'

FactoryBot.define do
  factory :user do
    username { Faker::Lorem.characters(number: 8) }
    email { Faker::Internet.unique.email }
    password { Faker::Lorem.characters(number: 10) }
  end
end