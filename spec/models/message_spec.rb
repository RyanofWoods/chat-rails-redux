require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:channel) do
    Channel.create!(name: "general")
  end

  let(:user) do
    User.create!(username: "exampleuser", email: "test@mail.com", password: "123456")
  end

  let(:valid_attributes) do
    {
      content: "awesome text",
      user: user,
      channel: channel
    }
  end

  let(:message) do
    Message.new(valid_attributes)
  end

  context "validations:" do
    it "should be valid with valid attributes" do
      expect(message).to be_valid
    end

    it "has a content" do
      expect(message.content).to eq("awesome text")
    end

    it "content must be present" do
      message.content = nil
      expect(message).not_to be_valid
    end
  end

  context "associations" do
    it "belongs to a user" do
      message.save!
      expect(message).to respond_to(:channel)
      expect(message.user).to eq(user)
    end

    it "belongs to a channel" do
      message.save!
      expect(message).to respond_to(:channel)
      expect(message.channel).to eq(channel)
    end
  end
end
