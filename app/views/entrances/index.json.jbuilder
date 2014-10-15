json.array!(@entrances) do |entrance|
  json.extract! entrance, :id, :employee_id, :clocked_at
  json.url entrance_url(entrance, format: :json)
end
