require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) do
    {
      username: "cooluser123",
      email: "test@mail.com",
      password: "123456"
    }
  end

  let(:user) do
    User.new(valid_attributes)
  end

  context "validations:" do
    it "should be valid with valid attributes" do
      expect(user).to be_valid
    end

    it "email must be present" do
      user.email = nil
      expect(user).not_to be_valid
    end

    it "password must be present" do
      user.password = nil
      expect(user).not_to be_valid
    end

    it "has a username" do
      expect(user.username).to eq("cooluser123")
    end

    it "username must be present" do
      user.username = nil
      expect(user).not_to be_valid
    end

    it "username must be unique and case insensitive" do
      user.save!
      attributes = valid_attributes
      attributes[:username] = attributes[:username].upcase
      attributes[:email] = "anunused@email.com"
      user2 = User.new(attributes)

      expect(user2).not_to be_valid
    end

    it "username should be between 3 and 15 characters (inclusive)" do
      user.username = "01"
      expect(user).not_to be_valid

      user.username = "0123456789abcde"
      expect(user).to be_valid

      user.username = "0123456789abcdef"
      expect(user).not_to be_valid
    end

    it "username should only contain letters, numbers, dashes and underscores" do
      invalid_usernames = ['te!st1', 'teSt.1', 'test ing', '#t3st', 't@est45', 'tes(t)', '[deleted]', 'hi"hi"']

      invalid_usernames.each do |user_string|
        user.username = user_string
        expect(user).not_to be_valid
      end

      user.username = "TesT_123"
      expect(user).to be_valid
    end

    it "should have an authentication token" do
      user.save!

      expect(user.authentication_token).not_to be(nil)
    end

    it "should gain standard authority on create" do
      expect(user.authority).to be(nil)
      expect(user.valid?).to be(true)

      user.save!

      expect(user.authority).to eq("standard")
    end

    it "should have .authority? method" do
      user.save!
      expect(user).to respond_to(:authority?)
    end

    it "should have .standard_authority? and .admin_authority? method" do
      user.save!
      expect(user).to respond_to(:standard_authority?, :admin_authority?)
    end
    it "should have .standard_authority! and .admin_authority! method" do
      user.save!
      expect(user).to respond_to(:standard_authority!, :admin_authority!)
    end
  end

  context "associations:" do
    it "should not delete their messages upon destroying" do
      user.save!
      channel = Channel.create!(name: "general")
      channel.messages.create!(user: user, content: "a lovely message")
      expect(User.find_by(username: user.username)).not_to eq(nil)
      expect(Message.count).to eq(1)

      user.destroy!

      # cannot check if user is deleted through User.count, as the reserved deleted user may be created during the test
      expect(User.find_by(username: user.username)).to eq(nil)
      expect(Message.count).to eq(1)
    end

    it "should have many channels" do
      user.save!
      expect(user).to respond_to(:channels)
      expect(user.channels.count).to eq(0)

      channel = Channel.create!(name: "general")
      channel.messages.create!(user: user, content: "a lovely message")

      expect(user.channels.count).to eq(1)
    end
  end
end
