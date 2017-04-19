class CompanyMailer < ApplicationMailer
  skip_before_action :requre_logged_in
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.company_mailer.registration_confirm.subject
  #


  def registration_confirm company
    @company = company

    mail to: @company.email, subject: "BID.AERO Confirmation Email"
  end

  def password_reset(company)
    @company =company

    mail to: company.email, subject: "Bid Aero Password Reset"
  end

  def invite_temp_user_to_bid(email, auction, opts = {})
    @invitee = Company.find_by(email: email)
    @confirmation_token = @invitee.confirm_token
    @auction = auction
    @conditions = AssetDecorator.rename(@auction, @auction.conditions)

    mail to: @invitee.email, subject: "#{auction.company.name} has invited you to participate in an RFQ"
  end

  def invite_existing_user_to_bid(email, auction, opts = {})
    @invitee = Company.find_by(email: email)
    @auction = auction
    @conditions = AssetDecorator.rename(@auction, @auction.conditions)

    mail to: @invitee.email, subject: "#{auction.company.name} has invited you to participate in an RFQ"
  end

  def notify_of_opportunity company , auction
    @company = company
    @auction = auction
    @conditions = AssetDecorator.rename(@auction, @auction.conditions)

    mail to: company.email, subject: "Opportunity to Sell Part Number:#{auction.part_num}"
  end

  def notify_buyer company, auction
    @company = company
    @auction = auction
    @conditions = AssetDecorator.rename(@auction, @auction.conditions)

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
    @bid = bid
    @auction = bid.auction
    @conditions = AssetDecorator.rename(@auction, @auction.conditions)

    mail to: "<#{bid.company.email}>", subject: "Bids are being placed in an auction you are participating in, find out how you rank!"
  end
end
