class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :projects, dependent: :destroy

  enum :role, { user: 0, admin: 1 }, prefix: :role
end
