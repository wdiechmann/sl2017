class MessageMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  
  # Default Mail Values
  default from: Rails.application.secrets.admin_email

  def thankyou_email(message,user)
    @message=message
    @token= "asdf"
    user ||= User.first
    # I am overriding the 'to' default
    mail(from: user.email, to: @message.email, subject: t('message_mailer.thankyou'))
  end

end
