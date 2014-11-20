json.array!(@messages) do |message|
  json.extract! message, :id, :title, :name, :street, :zip_city, :email, :msg_from, :msg_to, :body
  json.url message_url(message, format: :json)
end
