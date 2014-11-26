class Message < ActiveRecord::Base

	validates :name, presence: true
	validates :street, presence: true
	validates :zip_city, presence: true
	validates :email,  presence: true
	validates :body,  presence: true

end
