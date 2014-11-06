class JobberMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  
  # Default Mail Values
  default from: Rails.application.secrets.admin_email

  def welcome_email(jobber,user)
    @jobber=jobber
    @token= "asdf"
    user ||= User.first
    # I am overriding the 'to' default
    mail(from: user.email, to: @jobber.email, subject: t('jobber_mailer.welcome'))
  end

end
