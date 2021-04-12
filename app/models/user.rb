class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  validates :username, presence: true
  validates :username, uniqueness: { case_sensitive: false } # case sensitive by default
  validates :username, length: { in: 3..15 }
  validates :username, format: { with: /\A(\w|-)+\z/, message: "%{value} must only contain letters, numbers or underscores" } # any letter, number or underscore

  has_many :messages
  has_many :channels, through: :messages

  before_destroy :change_messages_owner

  private

  # user who is being deleted; replace all their messages user to our reserved one,
  # new message users' username will be ([deleted_user])
  def change_messages_owner
    username = reserved_deleted_user_hash[:username]
    replacement_user = User.find_by(username: username) || create_replacement_user
    
    if !replacement_user
      logger.error('Failed to replace messages with replacement user') 
      logger.error('Failed to find replacement_user in DB')
      logger.error('Failed to create replacement user based on ENV files')
      
      logger.error('Have to delete all the users messages anyway based on GDPR')
      self.messages.destroy_all
      return
    end

    self.messages.each do |message|
      message.update(user: replacement_user)
    end
  end

  def create_replacement_user
    reserve = reserved_deleted_user_hash
    return nil if !reserve

    replacement_user = User.new(reserve)
    replacement_user.save(validate: false)
    replacement_user
  end

  def reserved_deleted_user_hash
    username = ENV["RESERVED_DELETED_USER_USERNAME"]
    email = ENV["RESERVED_DELETED_USER_EMAIL"]
    password = ENV["RESERVED_DELETED_USER_PASSWORD"]

    return nil if !username || !email || !password
    return { username: username, email: email, password: password }
  end
end
