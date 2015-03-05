class Message < ActiveRecord::Base
	has_paper_trail

	validates :title,  presence: true
	# validates :msg_to, presence: true
	validates :body,  presence: true

	scope :unseen, ->() { where(["answered_at is null and msg_from is not null and msg_from <> '%s'", Rails.application.secrets.imap_user_name])}
	scope :answered, ->() { where(['answered_at is not null and msg_from is not null'])}
end
