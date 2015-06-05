class JobberDeliveryTeamResponsible < ActiveRecord::Migration
  def change
    add_column :jobbers, :dt_responsible, :boolean, default: false
  end
end
