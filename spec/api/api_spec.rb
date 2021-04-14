require 'rails_helper'
require 'pry-byebug'

RSpec.describe "API", type: :request do
  def channel_with_messages(message_count: 20, channel_name: 'test_channel')
    FactoryBot.create(:channel, name: channel_name) do |channel|
      FactoryBot.create_list(:message, message_count, channel: channel)
    end
  end

  let!(:channel) { channel_with_messages() }

  # '/api/v1/channels/:channel_name'
  before { get '/api/v1/channels/test_channel/messages' }
  
  context 'handles GET request' do
  it 'returns all messages from the #test_channel channel' do
    body = JSON.parse(response.body)
    p body
    expect(body).size.to eq(20)
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end
end

## FUTURE:
# update a message
# delete a message