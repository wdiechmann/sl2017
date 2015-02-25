class CreateDeliveryTeams < ActiveRecord::Migration
  def change
    create_table :delivery_teams do |t|
      t.string :title
      t.string :ancestry
      t.text :description

      t.timestamps
    end
  end
end
