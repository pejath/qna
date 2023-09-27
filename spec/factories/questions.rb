# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'Title' }
    body { 'body' }

    trait :invalid do
      title { nil }
    end

    trait :answer do
      after(:create) do |question|
        create(:answer, question_id: question.id)
      end
    end
  end
end
