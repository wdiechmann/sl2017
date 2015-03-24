class AddMessengerToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :messenger_id, :integer
    add_column :messages, :messenger_type, :string
  end
end
