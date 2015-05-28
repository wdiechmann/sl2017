class AddMessengerToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :messenger_id, :integer
    add_column :messages, :messenger_type, :string

    execute "ALTER TABLE messages CHANGE body body text CHARACTER SET 'utf8mb4' COLLATE utf8mb4_unicode_ci;"
  end
end
