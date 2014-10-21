class Entrance < ActiveRecord::Base
  belongs_to :employee
  
  validates :employee, presence: true
end
