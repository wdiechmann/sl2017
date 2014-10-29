json.array!(@punch_clocks) do |punch_clock|
  json.extract! punch_clock, :id, :user_id, :name
  json.url punch_clock_url(punch_clock, format: :json)
end
