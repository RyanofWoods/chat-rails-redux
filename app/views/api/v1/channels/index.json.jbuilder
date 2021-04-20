json.array! @channels do |channel|
  json.channel_name channel.name

  json.owner_username channel.owner&.username
end
