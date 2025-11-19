FactoryBot.define do
  factory :project do
    name { FFaker::Name.name }
    association :user
    association :color
  end
end
