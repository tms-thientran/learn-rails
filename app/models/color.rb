class Color < ApplicationRecord
  attribute :hex_code, :string

  def hex_code
    value = super || ""
    value.start_with?("#") ? value : "##{value}"
  end
end
