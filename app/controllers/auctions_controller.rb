class AuctionsController < ApplicationController
  before_action :set_auction, only: [:show, :edit, :update, :destroy]
  before_action :set_bid_and_auction, only: [:purchase_confirmation, :purchase]

  def index
    @myquotes_count = current_user.bids.to_a.uniq.count { |b| b.auction_id }
    @owned_auctions = current_user.auctions.where(active: true).where(project: nil)
    @pending_purchases_count = Transaction.where(buyer_id: current_user.id, complete: false).count
    @purchases_count = Transaction.where(buyer_id: current_user.id, complete: true).count
  end

  def show

    ## test to make sure that the bids from a temp user and a bid aero supplier are separated properly
    @auction_invitees = Company.find_invitees(@auction.invitees)


    @invited_suppliers_bids = @auction.bids.joins(:company).merge(@auction_invitees)
    @auction_invitees.empty? ? @bid_aero_suppliers_bids = @auction.bids.joins(:company) : @bid_aero_suppliers_bids =
      @auction.bids.joins(:company).where.not(companies: {id: @auction_invitees.pluck(:id)})
  end

  def auction_invites
    @auctions = Auction.where('invitees @> ?', {current_user.name.downcase => current_user.email.downcase}.to_json).decorate
  end

  def new
    @projects = current_user.projects
    @project = params[:project_id]
    @auction = Auction.new
  end

  def edit
  end

  def create
    auction_params[:target_price].gsub!(' ', '')
    params["invitees"].delete("")
    @auction = Auction.new(auction_params)
    @auction.set_invitees(params[:invitees]) if params[:invitees]
    part_match = Part.find_by(part_num: @auction.part_num.upcase)
    @auction.resale_check
    respond_to do |format|
      @auction.company = current_user
      @auction.condition.map!{ |x| x.to_sym }
      @auction.save
      @auction.invite_and_setup_suppliers

      @auction.req_forms.reject! { |c| c.empty? }
      Auction.part_match_or_not_actions(@auction, part_match)


      Notification.notify_of_opportunities(@auction, @auction.company, "You have a new opportunity to sell!")
      format.html { redirect_to @auction, notice: 'RFQ was successfully created.' }
      format.json { render :show, status: :created, location: @auction }
    end
  end

  def update
    respond_to do |format|
      params["invitees"].delete("")
      if params[:target_price]
        @auction.update(target_price: params[:target_price].gsub(' ', ''))
      elsif @auction.update(auction_params)
        @auction.set_invitees(params[:invitees]) if params[:invitees]
        @auction.invite_and_setup_suppliers
        @auction.update(condition: auction_params[:condition].map!{ |x| x.to_sym })
        # unless params[:commit] == "Update RFQ"
        #   @transaction = Transaction.find(transaction_params[:id])
        #   @transaction.update(transaction_params)
        # end
      else
        format.html { render :edit }
        format.json { render json: @auction.errors, status: :unprocessable_entity }
      end
      @auction.save
      format.html { redirect_to @auction, notice: 'RFQ was successfully updated.' }
      format.js { }
      format.json { render :show, status: :ok, location: @auction }
    end
  end

  def destroy
    @auction.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'RFQ was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def purchase_confirmation
      @transaction = Transaction.create_order(@bid) unless @bid.tx # change to Transaction.new, and next action Transaction.new(transaction_params) then @transaction.save
      if @auction.tx
        @auction.tx.destroy
        @transaction = Transaction.create_order(@bid)
      end
  end

  def current_opportunities
    @sales_opportunities = AuctionDecorator.decorate_collection(current_user.sales_opportunities)
    @todays_opportunity_count = 0
    Auction.find(current_user.sales_opportunities.map(&:id)).each { |x| @todays_opportunity_count +=1 if x.created_at.between?(DateTime.now.at_beginning_of_day.utc, Time.now.utc) }
  end


  private

    def notify_of_opportunities(message)
      parts = []
      parts = InventoryPart.where(part_num: @auction.part_num).each do |part|
        parts << part if @auction.condition.include?(part.condition) || @auction.condition == "All Conditions"
      end
      parts.uniq! { |p| p.company_id }
      parts.each do |part|
        Notification.create(company: part.company, auction: @auction, message: message) unless part.company == current_user
      end
    end

    def set_auction
      @auction = Auction.find(params[:id])
    end

    def set_bid_and_auction
      @auction = Auction.find(params[:auction_id])
      @bid = Bid.find(params[:id])
    end

    def auction_params
      params.require(:auction).permit(:company_id, :project_id, :part_num, :target_price, :cycles, :quantity, :destination_company,
                                      :destination_address, :destination_zip, :destination_city, :destination_state,
                                      :destination_country, :required_date, :resale_status, :resale_yes, :resale_no,
                                      condition: [], req_forms: [], invitees: [])
    end

    def transaction_params
      params.require(:auction).permit(transactions: [:id, :carrier, :shipping_account])[:transactions]
    end
end
