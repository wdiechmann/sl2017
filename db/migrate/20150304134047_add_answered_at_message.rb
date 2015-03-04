class AddAnsweredAtMessage < ActiveRecord::Migration
  def change
    add_column :messages, :answered_at, :datetime
  end
end
