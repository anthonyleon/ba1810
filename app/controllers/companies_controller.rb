class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_logged_in, only: [:new, :create]

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    # redirect_to root_path unless current_user.id == params[:id].to_i
    @auctions = current_user.auctions
    @buyer_auctions = current_user.auctions.where(active: true)
    @supplier_auctions = Bid.supplier_auctions(current_user.bids)
    possible_auctions = get_possible_auctions.uniq! || get_possible_auctions
    @possible_auctions = possible_auctions - @supplier_auctions - @buyer_auctions
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        session[:company_id] = @company.id
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    def get_possible_auctions
      possible_auctions = []
      @parts = current_user.inventory_parts

      @parts.each do |inv_part|
        if @auction_parts = AuctionPart.where(part_id: inv_part.part_id)
          @auction_parts.each do |auct_part|
            possible_auctions << auct_part.auction
          end
        end
      end
      possible_auctions
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :email, :password, :password_confirmation)
    end
end
