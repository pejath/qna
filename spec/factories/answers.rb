# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    association :question, factory: :question

    body { 'MyText' }

    trait :invalid do
      body { nil }
    end
  end
end
