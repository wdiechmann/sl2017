class MessageMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  # Default Mail Values
  default from: Rails.application.secrets.imap_reply_email
  layout 'mail_layout'

  def thankyou_email(message,user)
    @message=message
    @token= "asdf"
    user ||= User.first
    # I am overriding the 'to' default
    mail(to: @message.email, subject: t('message_mailer.thankyou'))
  end

  def message_email(message,text_body)
    @message= message
    @text_body= text_body
    mail(from: @message.msg_from, to: @message.msg_to, subject: @message.title)
  end



end
