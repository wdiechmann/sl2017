class UserMailer < ActionMailer::Base
  default from: "sl2017@alco.dk"

  def notify_admin_on_new_user(user)
    @user = user
    mail(from: Rails.application.secrets.admin_email, to: 'walt@alco.dk', reply_to: 'sl2017@alco.dk', subject: 'SLdb: Ny bruger godkendt!')
  end
  
end
