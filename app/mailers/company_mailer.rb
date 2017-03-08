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

  def password_reset(company)
    mail to: company.email, subject: "Password Reset"
  end

  def notify_of_opportunity company , auction
    @company = company 
    @auction = auction
    mail to: company.email, subject: "Opportunity to Sell #{auction.part_num}"
  end

  def place_new_bid bid
    @bid = bid
    email = @bid.company.email
    mail to: "<#{email}>", subject: "You Successfully Placed Bid in an Auction for #{@bid.auction.part_num}!"
  end

  def notify_buyer company, auction
    @company = company
    @auction = auction

    mail to: @company.email, subject: "A New Bid Has Been Place on Your Auction for #{auction.part_num}"
  end

  def won_auction_notification bid , seller , transaction
    @bid = bid
    @seller = seller
    @transaction = transaction

    mail to: seller.email, subject: "You won an auction" 
  end

  def send_escrow_money transaction , buyer 
    @transaction = transaction
    @buyer = transaction.buyer
   

    mail to: buyer.email, subject: "Transfer funds to escrow."
  end

  # This email is sent to instruct seller to ship the part
  def ship_part bid , seller
    @bid = bid
    @seller = seller

    mail to: seller.email, subject: "Funds have been released.  Ship your part."
  end

  def part_shipped bid , buyer , tx
    @bid = bid
    @buyer = buyer
    @tx = tx

    mail to: buyer.email, subject: "#{@bid.auction.part_num} has been shipped to you."
  end

  def shipment_received bid , seller
    @bid = bid
    @seller = seller 

    mail to: seller.email, subject: "Your shipment of has been received."
  end

  def funds_released bid , seller
    @bid = bid
    @seller = seller 

    mail to: seller.email, subject: "Funds have been released"
  end

  def order_canceled bid , seller , buyer
    @bid = bid
    @seller = seller
    @buyer = buyer

    mail to: seller.email, subject: "A transaction for a #{@bid.auction.part_num} has been cancelled"
  end   

  def auction_notification bid
    mail to: "<#{bid.company.email}>", subject: "Bids are being placed in an auction you are participating in, find out how you rank!"
  end
end
