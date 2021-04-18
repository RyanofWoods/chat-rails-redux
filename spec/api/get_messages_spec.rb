require 'rails_helper'
require_relative '../support/api_helper'

RSpec.describe "API#GET_MESSAGES", type: :request do
  let!(:channel) { channel_with_messages }
  let!(:current_user) { FactoryBot.create(:user) }
  let!(:headers) do
    {
      "X-User-Email": current_user.email,
      "X-User-Token": current_user.authentication_token
    }
  end

  def call_get(hdr = headers, channel_name = 'test_channel')
    get "/api/v1/channels/#{channel_name}/messages", headers: hdr
  end

  context 'GET request when not logged in' do
    it 'returns status code 401 (unauthorized) and error about signing in when given no email' do
      call_get(without_key(headers, :"X-User-Email"))

      expect(response).to have_http_status(401)
      expect(get_error(response)).to eq("You need to sign in or sign up before continuing.")
    end

    it 'returns status code 401 (unauthorized) and error about signing in when given no token' do
      call_get(without_key(headers, :"X-User-Token"))

      expect(response).to have_http_status(401)
      expect(get_error(response)).to eq("You need to sign in or sign up before continuing.")
    end
  end

  context 'GET request when logged in' do
    it 'returns status code 200 (success)' do
      call_get
      expect(response).to have_http_status(:success)
    end

    it 'returns all messages from the #test_channel channel' do
      call_get
      expect(JSON.parse(response.body).size).to eq(20)
    end

    it 'returns messages with the keys [id, user, content, created_at], but only shows users\' username' do
      call_get

      message = JSON.parse(response.body).first

      expect(message.key?("id")).to be(true)
      expect(message.key?("user")).to be(true)
      expect(message.key?("content")).to be(true)
      expect(message.key?("created_at")).to be(true)

      expect(message["user"].key?("username")).to be(true)
      expect(message["user"].key?("id")).to be(false)
      expect(message["user"].key?("created_at")).to be(false)
      expect(message["user"].key?("updated_at")).to be(false)
    end

    it "should return an empty array on a new channel" do
      new_channel = FactoryBot.create(:channel)
      call_get(headers, new_channel.name)

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).class).to be(Array)
      expect(JSON.parse(response.body).length).to eq(0)
    end

    it 'returns error when channel does not exist' do
      call_get(headers, "unexisting_channel")
      expect(get_error(response)).to eq("This channel does not exist.")
    end
  end
end
