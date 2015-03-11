class DeliveryTeam < ActiveRecord::Base
  has_paper_trail

  has_ancestry


  def list_title
    self.title
  end

end
