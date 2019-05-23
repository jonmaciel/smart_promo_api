# frozen_string_literal: true

FactoryBot.define do
  factory :partner do
    sequence(:name) { |n| "Name #{n}" }
  end
end
