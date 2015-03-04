class Message < ActiveRecord::Base
	has_paper_trail

	# validates :name, presence: true
	# validates :street, presence: true
	# validates :zip_city, presence: true
	# validates :email,  presence: true
	validates :title,  presence: true
	validates :body,  presence: true

	scope :unseen, ->() { where(["answered_at is null and msg_from is not null and msg_from <> '%s'", Rails.application.secrets.imap_user_name])}
	scope :answered, ->() { where(['answered_at is not null and msg_from is not null'])}
end
