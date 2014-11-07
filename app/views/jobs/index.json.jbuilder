json.array!(@jobs) do |job|
  json.extract! job, :id, :name, :location, :schedule, :description
  json.url job_url(job, format: :json)
end
