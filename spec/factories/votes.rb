# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    association :user, factory: :user
    association :votable, factory: :question
  end
end
