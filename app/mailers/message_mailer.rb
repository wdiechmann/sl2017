class MessageMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  # Default Mail Values
  default from: Rails.application.secrets.imap_reply_email

  def thankyou_email(message,user)
    @message=message
    @token= "asdf"
    user ||= User.first
    # I am overriding the 'to' default
    mail(to: @message.email, subject: t('message_mailer.thankyou'))
  end

  def message_email(message,jobber,job)
    @message=message
    @jobber=jobber
    @job=job
    # user ||= User.first
    # I am overriding the 'to' default
    mail(to: @message.msg_to, subject: @message.title)
  end

end
