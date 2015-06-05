if params[:l]=='true'
  json.array!(@jobbers) do |jobber|
    json.extract! jobber, :id, :name, :email
    json.url jobber_url(jobber, format: :json)
  end
else
  json.array!(@jobbers) do |jobber|
    json.extract! jobber, :id, :name, :street, :zip_city, :phone_number, :email, :confirmed_token, :confirmed_at
    json.url jobber_url(jobber, format: :json)
  end
end
