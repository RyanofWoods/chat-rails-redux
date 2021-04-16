def channel_with_messages(message_count: 20, channel_name: 'test_channel')
  FactoryBot.create(:channel, name: channel_name) do |channel|
    FactoryBot.create_list(:message, message_count, channel: channel)
  end
end
  
def without_key(hash, key)
  cpy = hash.dup
  cpy.delete(key)
  cpy
end

def get_error(response)
  JSON.parse(response.body)["error"]
end
