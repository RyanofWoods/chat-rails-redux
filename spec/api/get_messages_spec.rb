require 'rails_helper'
require_relative '../support/devise_helper'

RSpec.describe "API#GET_MESSAGES", type: :request do
  include DeviseHelper

  def channel_with_messages(message_count: 20, channel_name: 'test_channel')
    FactoryBot.create(:channel, name: channel_name) do |channel|
      FactoryBot.create_list(:message, message_count, channel: channel)
    end
  end

  let!(:channel) { channel_with_messages() }

  before do
    get '/api/v1/channels/test_channel/messages'
  end

  context 'GET request when not logged in' do
    it 'returns status code 401 (unauthorized)' do
      expect(response).to have_http_status(401)
    end

    it 'but gives authentication error' do
      body = JSON.parse(response.body)

      expect(body.has_key?("error")).to be(true)
      expect(body["error"]).to eq("You need to sign in or sign up before continuing.")
    end
  end
  
  context 'GET request when logged in' do
    before(:all) do
      current_user = FactoryBot.create(:user)
      login(current_user)
    end

    it 'returns status code 200 (success)' do
      expect(response).to have_http_status(:success)
    end

    it 'returns all messages from the #test_channel channel' do
      body = JSON.parse(response.body)
      expect(body.size).to eq(20)
    end

    it 'returns messages with the keys [id, user, content, created_at], but only shows users\' username' do
      message = JSON.parse(response.body).first

      expect(message.has_key? "id").to be(true)
      expect(message.has_key? "user").to be(true)
      expect(message.has_key? "content").to be(true)
      expect(message.has_key? "created_at").to be(true)

      expect(message["user"].has_key? "username").to be(true)
      expect(message["user"].has_key? "id").to be(false)
      expect(message["user"].has_key? "created_at").to be(false)
      expect(message["user"].has_key? "updated_at").to be(false)
    end
  end
end
