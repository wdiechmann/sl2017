class UserMailer < ActionMailer::Base
  default from: "clock@alco.dk"

  def notify_admin_on_new_user(user)
    @user = user
    mail(from: Rails.application.secrets.admin_email, to: 'walt@alco.dk', reply_to: 'clock@alco.dk', subject: 'CLOCK: Ny bruger godkendt!')
  end
  
end
