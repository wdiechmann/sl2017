class PunchClock < ActiveRecord::Base
  belongs_to :user
  has_many :employees
end
