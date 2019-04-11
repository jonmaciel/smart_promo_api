FactoryBot.define do
  factory :promotion do
    sequence(:name) { |n| "#{Faker::Lorem.word}-#{n}"}
  end
end
