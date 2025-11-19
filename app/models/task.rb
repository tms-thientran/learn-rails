class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :name, presence: true
  validates :content, presence: true

  def complete!
    update!(completed_at: Time.current)
  end

  def completed?
    completed_at.present?
  end
end
