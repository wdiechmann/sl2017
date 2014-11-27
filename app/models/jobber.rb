class Jobber < ActiveRecord::Base


	validates :name, presence: true
	validates :street, presence: true
	validates :zip_city, presence: true
	validates :phone_number,  presence: true
	validates :email,  presence: true
  
  # validates :jobber_assigned, :next_contact_at, :description, :jobbers_controlled
  
  def confirmed? params
    if self.confirmed_token == params[:confirmed_token]
      update_attributes confirmed_at: Time.now
      true
    else
      false
    end
  end
    
end
