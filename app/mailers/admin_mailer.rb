class AdminMailer < ApplicationMailer
  skip_before_action :requre_logged_in
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.company_mailer.registration_confirm.subject
  #

  def resale_uploaded
    mail to: 'support@bid.aero', subject: "Somebudy uploaded a resale certificate."
  end

  def registration_confirm company
    @company = company

    mail to: @company.email, subject: "BID.AERO Registration Confirmation"
  end
end
