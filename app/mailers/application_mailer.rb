class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.imap_reply_email
  layout 'mailer'
end
