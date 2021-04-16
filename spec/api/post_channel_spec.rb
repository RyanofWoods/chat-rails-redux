require 'rails_helper'
require_relative '../support/api_helper'

RSpec.describe "API#POST_CHANNEL", type: :request do
  let!(:current_user) { FactoryBot.create(:user) }
  let!(:headers)  {
                    {
                      "X-User-Email": current_user.email,
                      "X-User-Token": current_user.authentication_token
                    }
                  }
  let!(:parameters) { { "channel": { "name": "new_channel" } } }

  def call_post(prm = parameters, hdr = headers)
    post "/api/v1/channels/", params: prm, headers: hdr
  end

  context 'POST request when authenticated' do
    it 'should be successful when given user email, token and message content' do
      count_before = Channel.count

      call_post()

      expect(response).to have_http_status(:success)
      expect(Channel.count).to eq(count_before + 1)
    end

    it 'channel should be contain the given name' do
      call_post()

      created_channel = Channel.last
      expect(created_channel.name).to eq("new_channel")
    end

    it 'should fail when given wrong channel params' do
      count_before = Channel.count

      call_post({ "channel": { "bad_entry": "some text" } })

      expect(response).to have_http_status(422) # unprocessable entity
      expect(Channel.count).to eq(count_before)
    end
  end

  context 'POST request fails when not authenticated' do
    it 'should fail when given no email' do
      count_before = Channel.count

      call_post(parameters, without_key(headers, :"X-User-Email"))

      expect(response).to have_http_status(401) # not authorized
      expect(get_error(response)).to eq("You need to sign in or sign up before continuing.")
      expect(Channel.count).to eq(count_before)
    end
    
    it 'should be fail when given no token' do
      count_before = Channel.count
  
      call_post(parameters, without_key(headers, :"X-User-Token"))

      expect(response).to have_http_status(401) # not authorized
      expect(get_error(response)).to eq("You need to sign in or sign up before continuing.")
      expect(Channel.count).to eq(count_before)
    end
  end
end
