json.array!(@assignments) do |assignment|
  json.extract! assignment, :id, :job_id, :jobber_id, :assigned_at, :assigned_id, :assigned_type, :withdrawn_at, :withdrawn_id, :withdrawn_type
  json.url assignment_url(assignment, format: :json)
end
