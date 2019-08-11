# frozen_string_literal: true

FactoryBot.define do
  factory :advertisement do
    sequence(:title) { |n| "#{Faker::Lorem.word}-#{n}" }
  end
end
