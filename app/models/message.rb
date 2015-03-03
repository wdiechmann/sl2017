class Message < ActiveRecord::Base
	has_paper_trail

	validates :name, presence: true
	validates :street, presence: true
	validates :zip_city, presence: true
	validates :email,  presence: true
	validates :body,  presence: true

end
