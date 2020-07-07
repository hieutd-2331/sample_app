class ApplicationMailer < ActionMailer::Base
  default from: Settings.email_form
  layout 'mailer'
end
