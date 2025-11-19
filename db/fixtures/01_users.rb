require "ffaker"

FFaker::Internet.unique.clear

20.times do |i|
  User.seed(:email) do |s|
    s.id        = i + 1
    s.full_name = FFaker::NameVN.name
    s.email     = FFaker::Internet.unique.email
    s.password  = "password"
    s.role      = :user
  end
end
