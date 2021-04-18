class Channel < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :name, length: { in: 3..15 }
  validates :name,
            format: { with: /\A(\w|-)+\z/,
                      message: "%{value} must only contain letters, numbers, dashes or underscores" }

  has_many :messages, dependent: :destroy
  has_many :users, through: :messages
end
