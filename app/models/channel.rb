class Channel < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { maximum: 15 }

  has_many :messages, dependent: :destroy
  has_many :users, through: :messages
end
