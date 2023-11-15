# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    association :user, factory: :user

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

    trait :with_file do
      files { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")] }
    end

    trait :with_link do
      after(:create) do |question|
        create(:link, linkable: question)
      end
    end

    trait :with_comments do
      after(:create) do |question|
        create_list(:comment, 2, commentable: question)
      end
    end

    trait :with_reward do
      after(:create) do |question|
        create(:reward, question:)
      end
    end
  end
end
