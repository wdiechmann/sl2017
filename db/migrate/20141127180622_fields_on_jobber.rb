class FieldsOnJobber < ActiveRecord::Migration
  def change
    add_column :jobbers, :jobber_assigned, :datetime 
    add_column :jobbers, :next_contact_at, :datetime 
    add_column :jobbers, :description, :text
    add_column :jobbers, :jobbers_controlled, :integer, default: 1
  end
end
