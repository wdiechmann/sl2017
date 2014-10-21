class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  validates :name, presence: true

  def set_default_role
    self.role ||= :user
  end
  
  def good_roles

    User.roles.keys.map {|r| ([r.titleize,r] if User.roles[role] >= User.roles[r]) }
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
end
