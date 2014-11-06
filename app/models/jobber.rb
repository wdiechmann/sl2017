class Jobber < ActiveRecord::Base
  
  def confirmed? params
    if self.confirmed_token == params[:confirmed_token]
      update_attributes confirmed_at: Time.now
      true
    else
      false
    end
  end
    
end
