class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  before_create :create_account

  has_many :punch_clocks
  has_many :employees
  belongs_to :account
  
  validates :name, presence: true

  def create_account
    if self.account.nil?
      self.account= Account.create name: name
    end
  end

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
         
         
  # This is an internal method called every time Devise needs
  # to send a notification/mail. This can be overridden if you
  # need to customize the e-mail delivery logic. For instance,
  # if you are using a queue to deliver e-mails (delayed job,
  # sidekiq, resque, etc), you must add the delivery to the queue
  # just after the transaction was committed. To achieve this,
  # you can override send_devise_notification to store the
  # deliveries until the after_commit callback is triggered:
  #
  #     class User
  #       devise :database_authenticatable, :confirmable
  #
  #       after_commit :send_pending_notifications
  #
  #       protected
  #
  #       def send_devise_notification(notification, *args)
  #         # If the record is new or changed then delay the
  #         # delivery until the after_commit callback otherwise
  #         # send now because after_commit will not be called.
  #         if new_record? || changed?
  #           pending_notifications << [notification, args]
  #         else
  #           devise_mailer.send(notification, self, *args).deliver
  #         end
  #       end
  #
  #       def send_pending_notifications
  #         pending_notifications.each do |notification, args|
  #           devise_mailer.send(notification, self, *args).deliver
  #         end
  #
  #         # Empty the pending notifications array because the
  #         # after_commit hook can be called multiple times which
  #         # could cause multiple emails to be sent.
  #         pending_notifications.clear
  #       end
  #
  #       def pending_notifications
  #         @pending_notifications ||= []
  #       end
  #     end
  #
  # def send_devise_notification(notification, *args)
  #  devise_mailer.send(notification, self, *args).deliver
  # end
  
end
