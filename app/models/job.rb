class Job < ActiveRecord::Base

		validates :name, presence: true
		validates :location, presence: true
		validates :schedule, presence: true
		validates :priority, inclusion: { in: 1..5,
      message: "%{value} is not a valid priority" }
		validates :description,  presence: true

    scope :vacancies, ->(time) { where( ["vacancies > 0 and promote_job_at is not null and promote_job_at <= ? and delegated_at is null", time]).limit(20) }
end
