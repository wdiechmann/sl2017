class CreateEntrances < ActiveRecord::Migration
  def change
    create_table :entrances do |t|
      t.references :employee, index: true
      t.datetime :clocked_at

      t.timestamps
    end
  end
end
