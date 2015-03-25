class JobberMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  # Default Mail Values
  default from: Rails.application.secrets.imap_reply_email
  # layout 'mail_layout'

  def welcome_email(jobber,user)
    @jobber=jobber
    @token= "asdf"
    user ||= User.first
    # I am overriding the 'to' default
    mail(to: @jobber.email, subject: t('jobber_mailer.welcome'))
  end

  def first_email(message,text_body)
    @message= message
    @text_body= text_body
    mail(from: @message.msg_from, to: @message.msg_to, subject: @message.title)
  end

end
