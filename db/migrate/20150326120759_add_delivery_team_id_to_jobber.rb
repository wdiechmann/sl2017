class AddDeliveryTeamIdToJobber < ActiveRecord::Migration
  def change
    add_column :jobbers, :delivery_team_id, :integer
  end
end
