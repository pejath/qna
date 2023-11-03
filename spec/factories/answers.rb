# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    association :question, factory: :question
    association :user, factory: :user

    body { 'MyText' }

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")] }
    end

    trait :with_link do
      after(:create) do |answer|
        create(:link, linkable: answer)
      end
    end

    trait :with_comments do
      after(:create) do |answer|
        create_list(:comment, 2, commentable: answer)
      end
    end
  end
end
