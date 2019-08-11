# frozen_string_literal: true

FactoryBot.define do
  factory :promotion do
    sequence(:name) { |n| "#{Faker::Lorem.word}-#{n}" }
    cost { 1 }
    goal_quantity { 10 }
  end
end
