FactoryBot.define do
  factory :question do
    title { "Title" }
    body { "body" }

    trait :invalid do
      title { nil }
    end
  end
end
