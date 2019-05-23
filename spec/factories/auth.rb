# frozen_string_literal: true

FactoryBot.define do
  factory :auth do
    email { 'test@test.com' }
    cellphone_number { '41992855073' }
  end
end
