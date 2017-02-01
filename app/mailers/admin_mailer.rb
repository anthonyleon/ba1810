class AdminMailer < ApplicationMailer
  skip_before_action :requre_logged_in
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.company_mailer.registration_confirm.subject
  #

  def resale_uploaded(company, document)
    @company = company
    @document = document
    mail to: 'support@bid.aero', subject: "Somebudy uploaded a resale certificate."
  end

  def new_register(company)
    @company = company

    mail to: 'support@bid.aero', subject: "New Client Registration"
  end

  def new_auction(auction)
    @auction = auction
    @company = auction.company

    mail to: 'support@bid.aero', subject: 'SOMEONE JUST CREATED AN AUCTION' 
  end

  def new_lead(contact, company, phone, email, message)
    @name = contact
    @company = company
    @phone = phone
    @email = email
    @message = message

    mail to: 'support@bid.aero', subject: 'NEW LEAD!'
    
  end

  def no_part_match(auction)
    @auction = auction
    @company = auction.company

    mail to: 'support@bid.aero', subject: 'SOMEONE MADE AN AUCTION W NO MATCH TO PARTS_DB'
  end

  def no_matches_for_auction(company, auction)
    #company who created the auction
    @company = company
    @auction = auction

    mail to: 'support@bid.aero', subject: "No Matches To A New Auction"
  end

  def new_contact(company, phone, email, message)
    @company = company
    @phone = phone
    @email = email
    @message = message

    mail to: 'support@bid.aero', subject: "Someone filled out the contact form"
  end

end
