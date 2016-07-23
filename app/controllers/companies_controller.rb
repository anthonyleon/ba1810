class CompaniesController < ApplicationController
  require 'httparty'
  require 'nokogiri'
  require 'yahoo-finance'

  before_action :set_company, only: [:update, :destroy]
  skip_before_action :require_logged_in, only: [:new, :create, :confirm_email]
  before_action :set_armor_client, only: [:create, :edit, :update, :sales, :purchases]


  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @engines = Engine.all
    @aircrafts = Aircraft.all

    @company = current_user
    @auctions = current_user.auctions
    @buyer_auctions = current_user.auctions.where(active: true)
    @supplier_auctions = Bid.supplier_auctions(current_user.bids)
    possible_auctions = get_possible_auctions.uniq! || get_possible_auctions
    @possible_auctions = possible_auctions - @supplier_auctions - @buyer_auctions
    @inactive_auctions = current_user.auctions.where(active: false)

    yahoo_client = YahooFinance::Client.new
    @data = yahoo_client.quotes(["AER", "AYR", "FLY", "AL", "ACY", "WLFC"], [:symbol, :name, :ask, :change, :change_in_percent, :market_capitalization])
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
    @company = current_user
    auth_data = { 'uri' => "/accounts/#{current_user.armor_account_id}/bankaccounts", 'action' => 'create' }
    p result = @client.accounts.users(current_user.armor_account_id).authentications(current_user.armor_user_id).create(auth_data)
    p @url = result.data[:body]["url"]
  end

  def confirm_email
    company = Company.find_by(confirm_token: params[:format])
    if company
      company.email_activate
      redirect_to login_path, notice: 'Welcome to bid.aero, your email has been confirmed'
    else
      redirect_to root_path, notice: 'Sorry, company does not exist'
    end
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        CompanyMailer.registration_confirm(@company).deliver

        #armor user create
        # armor_create
        result = @client.accounts.create(@account_data)
        armor_account_num = result.data[:body]["account_id"].to_s
        @company.update(armor_account_id: armor_account_num)

        ## Company armor_user_id
        users = @client.accounts.users(armor_account_num).all
        @company.update(:armor_user_id => users.data[:body][0]["user_id"])

        # session[:company_id] = @company.id
        format.html { redirect_to root_path, notice: 'Please confirm your email address to complete registration.' }
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
      ## solely for testing purposes to set seed companies with an armor user id and account id
      if !@company.armor_account_id
        #armor user create
        # armor_create
        p result = @client.accounts.create(@account_data)
        p armor_account_num = result.data[:body]["account_id"].to_s
        @company.update(armor_account_id: armor_account_num)

        ## Company armor_user_id
        p users = @client.accounts.users(armor_account_num).all
        @company.update(:armor_user_id => users.data[:body][0]["user_id"])

      end
        format.html { redirect_to home_path, notice: 'Company was successfully updated.' }
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

  def sales
    @sales = []
    sales = Transaction.where(seller_id: current_user.id)
    sales.each do |sale|
      @sales << sale
    end
  end

  def purchases
    @purchases = []
    purchases = Transaction.where(buyer_id: current_user.id)
    purchases.each do |auction|
      @purchases << auction
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    def set_armor_client
      @client = ArmorPayments::API.new( ENV['ARMOR_PKEY'], ENV['ARMOR_SKEY'], true)
    end

    def armor_create
      @account_data = {
        company: @company.name,
        user_name: @company.representative,
        user_email: @company.email,
        user_phone: "+1 #{@company.phone.gsub('-', '')}",
        address: @company.address,
        city: @company.city,
        state: @company.state,
        zip: @company.zip,
        country: @company.country,
        email_confirmed: true,
        agreed_terms: true
        }
    end

    def get_possible_auctions
      possible_auctions = []
      @parts = current_user.inventory_parts

      @parts.each do |inv_part|
        if @auction_parts = AuctionPart.where(part_id: inv_part.part_id)
          @auction_parts.each do |auct_part|
            possible_auctions << auct_part.auction if auct_part.auction.active == true
          end
        end
      end
      possible_auctions
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :armor_id, :armor_user_id, :email, :EIN, :password, :password_confirmation, :representative, :phone, :address, :city, :state, :zip, :country)
    end
end
