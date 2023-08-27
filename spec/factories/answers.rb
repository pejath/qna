FactoryBot.define do
  factory :answer do
    association :question, factory: :question
    body { "MyText" }
  end
end
