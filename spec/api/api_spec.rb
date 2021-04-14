require 'rails_helper'

RSpec.describe "API", type: :request do
  def channel_with_messages(message_count: 20, channel_name: 'test_channel')
    FactoryBot.create(:channel, name: channel_name) do |channel|
      FactoryBot.create_list(:message, message_count, channel: channel)
    end
  end

  let!(:channel) { channel_with_messages() }

  # '/api/v1/:channel_name'
  before { get '/api/v1/test_channel/messages' }

  context 'handles GET request' do
    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns all messages from the #test_channel channel' do
      expect(JSON.parse(response.body).size).to eq(20)
    end 
  end
end

## FUTURE:
# update a message
# delete a message