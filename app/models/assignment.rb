class Assignment < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :job
  belongs_to :jobber
  belongs_to :assignee, polymorphic: true
  belongs_to :withdrawer, polymorphic: true

  scope :current, ->() { where( withdrawn_at: nil) }

end
