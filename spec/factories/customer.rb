FactoryBot.define do
  factory :customer do
    sequence(:name) { |n| "Name #{n}"}
  end
end
