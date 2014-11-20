class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.string :name
      t.string :street
      t.string :zip_city
      t.string :email
      t.string :msg_from
      t.string :msg_to
      t.text :body

      t.timestamps
    end
  end
end
