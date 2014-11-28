class Job < ActiveRecord::Base

		validates :name, presence: true
		validates :location, presence: true
		validates :schedule, presence: true
		validates :priority, inclusion: { in: 1..5,
      message: "%{value} is not a valid priority" }
		validates :description,  presence: true

    scope :vacancies, -> { where( "vacancies > 0 and delegated_at is null").limit(20) }
end
