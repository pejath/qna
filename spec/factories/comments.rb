# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    association :user
    body {"comment body"}
  end
end
