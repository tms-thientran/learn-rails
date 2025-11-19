require "ffaker"

color_ids = Color.pluck(:id)

if color_ids.size < 3
  default_colors = [
    { name: "Ruby Red", hex_code: "#FF0000" },
    { name: "Sunshine Yellow", hex_code: "#FFD700" },
    { name: "Ocean Blue", hex_code: "#1E90FF" }
  ]

  default_colors.each do |attrs|
    color = Color.find_or_create_by!(hex_code: attrs[:hex_code]) do |c|
      c.name = attrs[:name]
    end
    color_ids << color.id unless color_ids.include?(color.id)
  end
end

user_ids = User.pluck(:id)

raise "Seed users first" if user_ids.empty?
raise "Seed colors first" if color_ids.empty?

30.times do |i|
  Project.seed(:name, :user_id) do |s|
    s.id       = i + 1
    s.name     = "#{FFaker::Product.product_name} #{i + 1}"
    s.user_id  = user_ids.sample
    s.color_id = color_ids.sample
  end
end
