json.array! @channels do |channel|
  json.extract! channel, :name
end
