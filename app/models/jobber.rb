class Jobber < ActiveRecord::Base
	has_paper_trail

	belongs_to :delivery_team
	has_many :assignments
	has_many :jobs, through: :assignments
	has_many :received_messages, class_name: "Message", foreign_key: :msg_to, primary_key: :email
	has_many :sent_messages, class_name: "Message", foreign_key: :msg_from, primary_key: :email

	validates :name, presence: true
	validates :street, presence: true
	validates :zip_city, presence: true
	validates :phone_number,  presence: true
	validates :email,  presence: true

	scope :vacant, ->() { where( ["jobber_assigned is null and (next_contact_at is null or next_contact_at < ? )",Time.now]) }

  # validates :jobber_assigned, :next_contact_at, :description, :jobbers_controlled
  #
  # advanced validates example:
  # --------
  # BANNER = 'Taxation'
  # MIN_YEAR = 1980
  #
  # validates :docdate, date: true,
  #           inclusion: {
  #               in: Date.new(MIN_YEAR)..Time.now.to_date,
  #               message: "The date must be between #{Date.new(MIN_YEAR)} and #{Time.now.to_date}"},
  #           :if => lambda{ |object| object.doc_date.present? }
  # validates :year, :inclusion => { :in => MIN_YEAR..(Time.now.year),
  #                                  :message => "The year must be between #{MIN_YEAR} and #{Time.now.year}" },
  #           :if => lambda{ |object| object.year.present? }

	attr_accessor :job_id, :job_name

	def messages
		msg = Message.arel_table
		sent = msg[:msg_from].eq(email)
		received = msg[:msg_to].eq(email)
		Message.where(sent.or(received))
	end

  def confirmed? params
    if self.confirmed_token == params[:confirmed_token]
      update_attributes confirmed_at: Time.now
      true
    else
      false
    end
  end

	def confirm!
		self.update_attributes confirmed_at: Time.now
	end

	# find a job attached to the jobber and assign the jobber
	def assign_job assignee
		return if self.job_id.nil?
		Job.find(self.job_id).assign_jobber(self,assignee)
	rescue
		true
	end


  def list_title
    self.name
  end


end
