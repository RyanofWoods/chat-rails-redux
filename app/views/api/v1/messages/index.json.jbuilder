json.array! @messages do |message|
  json.extract! message, :id, :created_at, :content

  json.user do
    json.extract! message.user, :username
  end 
end