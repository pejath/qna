# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    title { 'Reward' }
    association :question, factory: :question
    association :user, factory: :user
  end
end
