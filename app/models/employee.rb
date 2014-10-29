class Employee < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :entrances
  belongs_to :punch_clock
  belongs_to :user

end
