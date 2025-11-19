FactoryBot.define do
  factory :color do
    name { FFaker::Color.name }
    hex_code { FFaker::Color.hex_code }
  end
end
