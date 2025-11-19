require "ffaker"

user_ids    = User.pluck(:id)
project_ids = Project.pluck(:id)

raise "Seed users and projects first" if user_ids.empty? || project_ids.empty?

100.times do |i|
  Task.seed(:id) do |s|
    s.id            = i + 1
    s.name          = FFaker::Lorem.words(3).join(" ").titleize
    s.content       = FFaker::Lorem.sentence
    s.user_id       = user_ids.sample
    s.project_id    = project_ids.sample
    s.deadline_time = FFaker::Time.datetime
  end
end
