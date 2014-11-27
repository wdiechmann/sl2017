class FieldsJob < ActiveRecord::Migration
  def change
    add_column :jobs, :priority,       :integer, default: 1
    add_column :jobs, :delegated_at,   :datetime
    add_column :jobs, :jobbers_min,    :integer, default: 1
    add_column :jobs, :jobbers_wanted, :integer, default: 1
    add_column :jobs, :jobbers_max,    :integer, default: 1
    add_column :jobs, :vacancies,      :integer, default: 1
  end
end
