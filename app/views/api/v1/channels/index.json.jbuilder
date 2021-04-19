json.array! @channels do |channel|
  json.extract! channel, :name
  if channel.owner
    json.owner_username { json.extract! channel.owner, :username }
  end
end
