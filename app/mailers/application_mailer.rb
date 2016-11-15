class ApplicationMailer < ActionMailer::Base
	add_template_helper(EmailHelper)
  default from: "no-reply@bid.aero"
  layout 'mailer'
end
