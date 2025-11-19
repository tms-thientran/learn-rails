FactoryBot.define do
  factory :user do
    full_name { FFaker::NameVN.name }
    email { FFaker::Internet.email }
    password { "password" }
  end
end
