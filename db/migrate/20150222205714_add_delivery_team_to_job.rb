class AddDeliveryTeamToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :delivery_team_id, :integer
  end
end
