FactoryBot.define do
  factory :prize do
    sequence(:name) { |n| "Name #{n}"}

    promotion
  end
end
