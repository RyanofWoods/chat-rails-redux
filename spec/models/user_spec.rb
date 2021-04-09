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

    it "has a username" do
      expect(user.username).to eq("cooluser123")
    end

    it "email must be present" do
      user.email = nil
      expect(user).not_to be_valid
    end

    it "password must be present" do
      user.password = nil
      expect(user).not_to be_valid
    end

    it "username must be present" do
      user.username = nil
      expect(user).not_to be_valid
    end

    it "username must be unique" do
      user.save!
      user2 = User.new(valid_attributes)
      expect(user).not_to be_valid
    end

    it "username should be less than 11 characters" do
      user.username = "0123456789a"
      expect(user).not_to be_valid
    end

    it "should not delete their messages upon destroying" do
      user.save!
      channel.create!(name: general)
      channel.messages.create!(user: user, content: "a lovely message")
      expect { user.destroy }.not_to change { Message.count }.from(1).to(0)
    end
  end
  
  context "associations:" do
    it "should have many channels" do
      user.save!
      expect(user).to respond_to(:channels)
      expect(user.channels.count).to eq(0)

      channel = Channel.create!(valid_attributes)
      channel.messages.create!(user: user, content: "a lovely message")

      expect(user.channels.count).to eq(1)
    end
  end
end
