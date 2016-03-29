class CompanyMailer < ApplicationMailer
  skip_before_action :requre_logged_in

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.company_mailer.registration_confirm.subject
  #
  def registration_confirm company
    @company = company

    mail to: "#{@company.name} <#{@company.email}>", subject: "Confirm your registration with Bid.Aero"
  end

  def new_bids bid
     @bid = bid
     email = @bid.company.email

    mail to: " <#{email}>", subject: "new bids in auction!"
  end
end
