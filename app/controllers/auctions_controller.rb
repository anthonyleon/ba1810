class AuctionsController < ApplicationController
  before_action :set_auction, only: [:show, :edit, :update, :destroy]
  before_action :set_bid_and_auction, only: [:purchase_confirmation, :purchase]

  def index
    @owned_auctions = current_user.auctions.where(active: true).decorate
  end

  def show
    @auction = @auction.decorate
  end

  def new
    @auction = Auction.new
  end

  def edit
  end

  def create
    @auction = Auction.new(auction_params)
    part_match = Part.find_by(part_num: @auction.part_num.upcase)
    @auction.resale_check

    respond_to do |format|
      @auction.company = current_user
      @auction.condition.map!{ |x| x.to_sym }
      @auction.save
      Auction.part_match_or_not_actions(@auction, part_match)

      
      Notification.notify_of_opportunities(@auction, @auction.company, "You have a new opportunity to sell!")
      format.html { redirect_to @auction, notice: 'Auction was successfully created.' }
      format.json { render :show, status: :created, location: @auction }
      # else
      #   flash[:error] = "Part number is not valid"
      #   format.html { redirect_to new_auction_path, alert: 'That part does not exist in our database.' }
      # end
    end
  end

  def update
    respond_to do |format|
      if params[:target_price]
        @auction.update(target_price: params[:target_price])
      elsif @auction.update(auction_params)
        unless params[:commit] == "Update Auction"
          @transaction = Transaction.find(transaction_params[:id])
          @transaction.update(transaction_params)
        end
      else
        format.html { render :edit }
        format.json { render json: @auction.errors, status: :unprocessable_entity }
      end
      format.html { redirect_to @auction, notice: 'Auction was successfully updated.' }
      format.js { }
      format.json { render :show, status: :ok, location: @auction }
    end
  end

  def destroy
    @auction.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Auction was successfully destroyed.' }
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
      params.require(:auction).permit(:company_id, :part_num, :target_price, :cycles, :quantity, :destination_company, :destination_address, :destination_zip, :destination_city, :destination_state, :destination_country, :required_date, :resale_status, :resale_yes, :resale_no, condition: [])
    end

    def transaction_params
      params.require(:auction).permit(transactions: [:id, :carrier, :shipping_account])[:transactions]
    end
end
