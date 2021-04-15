require 'rails_helper'
require_relative '../support/devise_helper'
require 'pry-byebug'

RSpec.describe "API#POST_MESSAGE", type: :request do
  include DeviseHelper

  def channel_with_messages(message_count: 5, channel_name: 'test_channel')
    FactoryBot.create(:channel, name: channel_name) do |channel|
      FactoryBot.create_list(:message, message_count, channel: channel)
    end
  end
  
  def message_count
    Channel.find_by(name: 'test_channel').messages.count
  end

  let!(:channel) { channel_with_messages() }
  let!(:current_user) { FactoryBot.create(:user) }
  let!(:headers)  {
                    {
                      "X-User-Email": current_user.email,
                      "X-User-Token": current_user.authentication_token
                    }
                  }
  let!(:parameters) { { "message": { "content": "some text" } } }

  def without_key(hash, key)
    cpy = hash.dup
    cpy.delete(key)
    cpy
  end

  def call_post(prm = parameters, hdr = headers)
    post '/api/v1/channels/test_channel/messages', params: prm, headers: hdr
  end

  context 'POST request when authenticated' do
    it 'should be successful when given user email, token and message content' do
      count_before = message_count()

      call_post()

      expect(response).to have_http_status(:success)
      expect(message_count()).to eq(count_before + 1)
    end

    it 'message should be assigned to the correct channel and user' do
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
  end

  context 'POST request fails when not authenticated' do
    it 'should fail when given no email' do
      count_before = message_count()

      call_post(parameters, without_key(headers, :"X-User-Email"))

      expect(response).to have_http_status(401) # not authorized
      expect(message_count()).to eq(count_before)
    end
    
    it 'should be fail when given no token' do
      count_before = message_count()
  
      call_post(parameters, without_key(headers, :"X-User-Token"))

      expect(response).to have_http_status(401) # not authorized
      expect(message_count()).to eq(count_before)
    end
  end
end
