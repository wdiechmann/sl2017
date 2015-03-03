class JobMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  # Default Mail Values
  default from: Rails.application.secrets.admin_email
  layout 'job_confirm'

  def job_confirm(job,user)
    @job=job
    @token= "asdf"
    user ||= User.first
    # I am overriding the 'to' default
    mail(to: user.email, subject: t('job_mailer.thankyou'))
  end
end
