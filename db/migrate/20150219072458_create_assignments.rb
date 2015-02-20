class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :job, index: true
      t.references :jobber, index: true
      t.datetime :assigned_at
      t.integer :assignee_id
      t.string :assignee_type
      t.datetime :withdrawn_at
      t.integer :withdrawer_id
      t.string :withdrawer_type
      t.string :withdrawn_reason
      t.integer :status

      t.timestamps
    end
  end
end
