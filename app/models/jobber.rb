class Jobber < ActiveRecord::Base


	validates :name, presence: true
	validates :street, presence: true
	validates :zip_city, presence: true
	validates :phone_number,  presence: true
	validates :email,  presence: true

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


  def confirmed? params
    if self.confirmed_token == params[:confirmed_token]
      update_attributes confirmed_at: Time.now
      true
    else
      false
    end
  end

end
