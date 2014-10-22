module EntrancesHelper

  def show_clocked_at entrance
    return '' if entrance.clocked_at.blank?
    entrance.clocked_at.strftime '%d/%m/%Y %H:%M'
  end
  
end
