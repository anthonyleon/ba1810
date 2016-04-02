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

  def place_new_bid bid
    @bid = bid
    email = @bid.company.email

    mail to: "<#{email}>", subject: "Placed Bid in Auction #{@bid.auction_id}!"
  end

  def auction_notification bid
    @bid = bid
    @bidders = Bid.where(auction_id: @bid.auction)
    @single_bidder = []
    Company.uniq(@bidders)

    @bidders.each do |bidder|
      @single_bidder << bidder.company.email
    end

    @single_bidder.each do |bidder|
      mail to: "<#{bidder}>", subject: "Placed Bid in Auction #{@bid.auction_id}!"
    end
  end
end
