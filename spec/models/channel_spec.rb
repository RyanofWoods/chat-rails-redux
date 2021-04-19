require 'rails_helper'

RSpec.describe Channel, type: :model do
  let(:valid_attributes) do
    {
      name: "general"
    }
  end

  let(:channel) do
    Channel.new(valid_attributes)
  end

  let(:user) do
    User.new(username: "example123", email: "test@mail.com", password: "123456")
  end

  context "validations:" do
    it "should be valid with valid attributes (even without an owner)" do
      expect(channel).to be_valid
    end

    it "has a name" do
      expect(channel.name).to eq("general")
    end

    it "name must be present" do
      channel.name = nil
      expect(channel).not_to be_valid
    end

    it "name must be unique and case sensitive" do
      channel.save!
      channel2 = Channel.new(valid_attributes)
      expect(channel2).not_to be_valid

      upcase_attr = valid_attributes
      upcase_attr[:name] = valid_attributes[:name].upcase
      channel3 = Channel.new(upcase_attr)
      expect(channel3).not_to be_valid
    end

    it "name should only contain letters, numbers and dashes" do
      invalid_names = ['gen!eral1', 'general.1', 'gen eral', ' javascript', 'ruby ', '#t3eral', 't@eeral45',
                       'gens(t)', '[deleted]', 'hi"hi"']

      invalid_names.each do |name|
        channel.name = name
        expect(channel).not_to be_valid
      end

      channel.name = "General-123"
      expect(channel).to be_valid
    end

    it "username should be between 3 and 15 characters (inclusive)" do
      channel.name = "01"
      expect(channel).not_to be_valid

      channel.name = '0123456789abcde'
      expect(channel).to be_valid

      channel.name = '0123456789abcdef'
      expect(channel).not_to be_valid
    end
  end

  context "associations:" do
    it "should have many messages" do
      channel.save!
      expect(channel).to respond_to(:messages)

      expect(channel.messages.count).to eq(0)

      user.save!
      channel.messages.create!(user: user, content: "a lovely message")
      expect(channel.messages.count).to eq(1)
    end

    it "should have many users through messages" do
      channel = Channel.create!(valid_attributes)
      expect(channel).to respond_to(:users)

      expect(channel.users.count).to eq(0)

      user.save!
      channel.messages.create!(user: user, content: "a lovely message")
      expect(channel.users.count).to eq(1)
    end

    it "belongs to a user, but is renamed as owner" do
      user.save!
      new_channel = user.channels.create(valid_attributes)

      expect(new_channel).to respond_to(:owner)
      expect(new_channel.owner).to eq(user)
    end

    it "should delete its messages upon destroying" do
      user.save!
      channel.save!
      channel.messages.create!(user: user, content: "a lovely message")
      expect { channel.destroy }.to change { Message.count }.from(1).to(0)
    end
  end
end
