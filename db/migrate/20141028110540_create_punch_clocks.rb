class CreatePunchClocks < ActiveRecord::Migration
  def change
    create_table :punch_clocks do |t|
      t.references :user, index: true
      t.string :name

      t.timestamps
    end
  end
end
