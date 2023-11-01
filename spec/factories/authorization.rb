# frozen_string_literal: true

FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { 'Github' }
    uid { 'MyString' }
  end
end
