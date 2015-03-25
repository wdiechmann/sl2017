class JobMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  # Default Mail Values
  default from: Rails.application.secrets.imap_reply_email
  layout 'mail_layout'

  def job_confirm(message,text_body)
    @message= message
    @text_body= text_body
    mail(from: @message.msg_from, to: @message.msg_to, subject: @message.title)
  end
end
