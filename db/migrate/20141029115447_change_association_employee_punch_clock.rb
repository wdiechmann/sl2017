class ChangeAssociationEmployeePunchClock < ActiveRecord::Migration
  def change
    remove_reference :employees, :user
    add_reference :employees, :account, index: true

    remove_reference :punch_clocks, :user
    add_reference :punch_clocks, :account, index: true
  end
end
