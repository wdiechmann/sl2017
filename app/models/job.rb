class Job < ActiveRecord::Base

		validates :name, presence: true
		validates :location, presence: true
		validates :schedule, presence: true
		validates :description,  presence: true

end
