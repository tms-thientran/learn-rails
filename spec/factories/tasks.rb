FactoryBot.define do
  factory :task do
    name { FFaker::Name.name }
    content { FFaker::Lorem.paragraph }
    association :project
    association :user
  end
end
