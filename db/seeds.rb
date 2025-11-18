# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

colors = [
  {
    name: 'Red',
    hex_code: 'FF0000'
  },
  {
    name: 'Yellow',
    hex_code: 'FFFF00'
  },
  {
    name: 'Orange',
    hex_code: 'FFA500'
  }
]

colors.each do |color|
  Color.find_or_create_by!(hex_code: color[:hex_code]) do |c|
    c.name = color[:name]
  end
end
