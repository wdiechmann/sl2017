module DeliveryTeamsHelper
  def delivery_team_collection
    DeliveryTeam.ancestry_options(DeliveryTeam.unscoped.arrange(:order => 'title')) {|i| "#{'-' * i.depth} #{i.title}" }
  end

end
