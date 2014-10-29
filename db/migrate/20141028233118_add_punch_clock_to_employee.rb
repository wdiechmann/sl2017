class AddPunchClockToEmployee < ActiveRecord::Migration
  def change
    add_reference :employees, :user, index: true
    add_reference :employees, :punch_clock, index: true
  end
end
