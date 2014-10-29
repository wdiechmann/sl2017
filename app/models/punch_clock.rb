class PunchClock < ActiveRecord::Base

  validates :name, presence: true

  belongs_to :account
  has_many :employees
end
