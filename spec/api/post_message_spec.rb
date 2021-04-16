require 'rails_helper'
require_relative '../support/api_helper'

RSpec.describe "API#POST_MESSAGE", type: :request do
  let!(:channel) { channel_with_messages() }
  let!(:current_user) { FactoryBot.create(:user) }
  let!(:headers)  {
                    {
                      "X-User-Email": current_user.email,
                      "X-User-Token": current_user.authentication_token
                    }
                  }
  let!(:parameters) { { "message": { "content": "some text" } } }

  def call_post(prm = parameters, hdr = headers, channel_name = 'test_channel')
    post "/api/v1/channels/#{channel_name}/messages", params: prm, headers: hdr
  end

  context 'POST request when authenticated' do
    it 'should be successful when given user email, token and message content' do
      count_before = message_count()

      call_post()

      expect(response).to have_http_status(:success)
      expect(message_count()).to eq(count_before + 1)
    end

    it '- message should be assigned to the correct channel and user' do
      call_post()

      created_message = Message.last

      expect(created_message.content).to eq("some text")
      expect(created_message.channel.name).to eq("test_channel")
      expect(created_message.user).to eq(current_user)
    end

    it 'should fail when given wrong message params' do
      count_before = message_count()

      call_post({ "message": { "text": "some text" } })

      expect(response).to have_http_status(422) # unprocessable entity
      expect(message_count()).to eq(count_before)
    end

    it 'should fail and give error about channel not existing when given a invalid channel name' do
      count_before = message_count()
      call_post(parameters, headers, 'unexisting_channel')

      expect(response).to have_http_status(422) # unprocessable entity
      expect(get_error(response)).to eq("This channel does not exist.")
      expect(message_count()).to eq(count_before)
    end
  end

  context 'POST request fails when not authenticated' do
    it 'should fail when given no email' do
      count_before = message_count()

      call_post(parameters, without_key(headers, :"X-User-Email"))

      expect(response).to have_http_status(401) # not authorized
      expect(get_error(response)).to eq("You need to sign in or sign up before continuing.")
      expect(message_count()).to eq(count_before)
    end
    
    it 'should be fail when given no token' do
      count_before = message_count()
  
      call_post(parameters, without_key(headers, :"X-User-Token"))

      expect(response).to have_http_status(401) # not authorized
      expect(get_error(response)).to eq("You need to sign in or sign up before continuing.")
      expect(message_count()).to eq(count_before)
    end
  end
end
