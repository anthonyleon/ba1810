class CompanyMailer < ApplicationMailer
  skip_before_action :requre_logged_in

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.company_mailer.registration_confirm.subject
  #

  def registration_confirm company
    @company = company

    mail to: @company.email, subject: "BID.AERO Registration Confirmation"
  end

  def place_new_bid bid
    @bid = bid
    email = @bid.company.email

    mail to: "<#{email}>", subject: "You Successfully Placed Bid in an Auction for #{@bid.auction.part_num}!"
  end

  def notify_buyer auction
    @company = auction.company

    mail to: @company.email, subject: "A New Bid Has Been Place on Your Auction for #{auction.part_num}"
  end

  def auction_notification bid
    @bid = bid
    @bidders = Bid.where(auction_id: @bid.auction_id)
    @single_bidder = []
    Company.uniq(@bidders)

    @bidders.each do |bidder|
      @single_bidder << bidder.company.email
    end

    @single_bidder.each do |bidder|
      mail to: "<#{bidder}>", subject: "Bids are being placed in an Auction #{@bid.auction_id}, find out how you rank!"
    end
  end
end
