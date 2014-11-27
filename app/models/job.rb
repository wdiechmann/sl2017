class Job < ActiveRecord::Base

		validates :name, presence: true
		validates :location, presence: true
		validates :schedule, presence: true
		validates :priority, inclusion: { in: 1..5,
      message: "%{value} is not a valid priority" }
		validates :description,  presence: true

end
