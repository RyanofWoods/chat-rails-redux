require 'faker'

FactoryBot.define do
  factory :message do
    content { Faker::Lorem.sentence }
    channel
    user
  end
end
