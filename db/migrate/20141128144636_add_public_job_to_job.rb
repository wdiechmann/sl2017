class AddPublicJobToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :promote_job_at, :datetime
  end
end
