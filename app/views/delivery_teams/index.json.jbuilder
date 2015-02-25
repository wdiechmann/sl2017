json.array!(@delivery_teams) do |delivery_team|
  json.extract! delivery_team, :id, :title, :ancestry, :description
  json.url delivery_team_url(delivery_team, format: :json)
end
