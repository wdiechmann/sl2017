class Job < ActiveRecord::Base
	has_paper_trail

	has_many :assignments
	has_many :current_assignments, -> { where withdrawn_at: nil }, class_name: 'Assignment'
	has_many :jobbers, through: :assignments
	has_many :current_jobbers, through: :current_assignments, class_name: 'Jobber', source: :jobber
	belongs_to :delivery_team

	validates :name, presence: true
	validates :location, presence: true
	validates :schedule, presence: true
	validates :priority, inclusion: { in: 1..5,
    message: "%{value} is not a valid priority" }
	validates :description,  presence: true

  scope :vacancies, ->(time) { where( ["vacancies > 0 and promote_job_at is not null and promote_job_at <= ? and delegated_at is null", time]).limit(20) }

	def assign_jobber jobber, assignee
		return true if current_jobbers.include? jobber
		assignments << Assignment.create( job: self, jobber: jobber, assigned_at: DateTime.now, assignee: assignee )
	end

end
