# frozen_string_literal: true

FactoryBot.define do
  factory :auth do
    email { 'test@test.com' }
    cellphone_number { '41992855073' }
    password { '1234' }
    password_confirmation { '1234' }

    trait :adm do
      adm { true }
    end
  end
end
