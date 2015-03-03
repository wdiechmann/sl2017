class Account < ActiveRecord::Base
  has_paper_trail
  
  has_many :users
  has_many :employees
  has_many :punch_clocks
end
