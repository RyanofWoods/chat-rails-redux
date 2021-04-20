require 'rails_helper'
require_relative '../support/api_helper'

RSpec.describe "API#GET_CHANNELS", type: :request do
  let!(:channels) { FactoryBot.create_list(:channel, 10) }
  let!(:current_user) { FactoryBot.create(:user) }
  let!(:headers) do
    {
      "X-User-Email": current_user.email,
      "X-User-Token": current_user.authentication_token
    }
  end

  def call_get(hdr = headers)
    get "/api/v1/channels/", headers: hdr
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
    it 'returns status code 200 (success) and all channels' do
      call_get
      expect(response).to have_http_status(:success)

      expect(JSON.parse(response.body).size).to eq(Channel.count)
    end

    it 'returns only channel name, no id if there is no owner' do
      call_get

      channel_json = JSON.parse(response.body).first

      expect(channel_json.key?("channel_name")).to be(true)
      expect(channel_json.key?("id")).to be(false)
      expect(channel_json.key?("owner_username")).to be(true)
      expect(channel_json["owner_username"]).to eq(nil)
    end

    it 'returns only channel name, no id and also channel owner_username if there is an owner' do
      Channel.destroy_all
      current_user.owned_channels.create(name: "general")

      call_get

      channel_json = JSON.parse(response.body).first

      expect(channel_json.key?("channel_name")).to be(true)
      expect(channel_json.key?("id")).to be(false)

      expect(channel_json["owner_username"]).to eq(current_user.username)
    end

    it "should return an empty when there are no channels" do
      Channel.destroy_all

      call_get
      expect(JSON.parse(response.body).length).to eq(0)
    end
  end
end
