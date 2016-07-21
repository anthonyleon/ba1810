class AuctionPartsController < ApplicationController
  before_action :set_auction_part, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @auction = Auction.new
    @auction_part = AuctionPart.new
  end

  def edit
  end

  def create
    @auction_part = AuctionPart.new(auction_part_params)

    respond_to do |format|
      if @auction_part.save
        format.html { redirect_to @auction_part, notice: 'Auction part was successfully created.' }
        format.json { render :show, status: :created, location: @auction_part }
      else
        format.html { render :new }
        format.json { render json: @auction_part.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @auction_part.update(auction_part_params)
        format.html { redirect_to @auction_part, notice: 'Auction part was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_part }
      else
        format.html { render :edit }
        format.json { render json: @auction_part.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @auction_part.destroy
    respond_to do |format|
      format.html { redirect_to auction_parts_url, notice: 'Auction part was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_auction_part
      @auction_part = AuctionPart.find(params[:id])
    end

    def auction_part_params
      params.require(:auction_part).permit(:part_num, :init_price, :part_id, :auction_id, :condition)
    end
end
