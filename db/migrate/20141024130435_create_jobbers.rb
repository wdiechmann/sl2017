class CreateJobbers < ActiveRecord::Migration
  def change
    create_table :jobbers do |t|
      t.string :name
      t.string :street
      t.string :zip_city
      t.string :phone_number
      t.string :email
      t.string :confirmed_token
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
