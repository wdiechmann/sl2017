class UserMailer < ActionMailer::Base
  default from: Rails.application.secrets.imap_reply_email

  def notify_admin_on_new_user(user)
    @user = user
    mail(to: 'walt@alco.dk', reply_to: 'sl2017@alco.dk', subject: 'SLdb: Ny bruger godkendt!')
  end

end
