class Project < ApplicationRecord
  belongs_to :color
  belongs_to :user
  has_many :tasks, dependent: :destroy
  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id name color_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[color]
  end
end
