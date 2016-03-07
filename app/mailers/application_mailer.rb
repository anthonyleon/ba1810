class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@bid.aero"
  layout 'mailer'
end
