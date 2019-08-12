# frozen_string_literal: true

FactoryBot.define do
  factory :partner do
    sequence(:name) { |n| "Name #{n}" }
    adress { 'adress' }
    cnpj { '18210092000108' }
  end
end
