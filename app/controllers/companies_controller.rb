class CompaniesController < ApplicationController
  require 'httparty'
  require 'nokogiri'
  require 'yahoo-finance'

  before_action :set_company, only: [:update, :destroy]
  skip_before_action :require_logged_in, only: [:new, :create, :confirm_email, :update]
  # before_action :set_armor_client, only: [:create, :edit, :update, :sales, :purchases]

  def show
    @engines = Engine.all
    @aircrafts = Aircraft.all
    @company = current_user
    @auctions = current_user.auctions
    @supplier_auctions = Bid.supplier_auctions(current_user.bids)
    possible_auctions = current_user.get_possible_auctions.uniq!
    @possible_auctions = possible_auctions - @supplier_auctions
    @inactive_auctions = current_user.auctions.where(active: false)
    yahoo_client = YahooFinance::Client.new
    @data = yahoo_client.quotes(["AER", "AYR", "FLY", "AL", "ACY", "WLFC"], [:symbol, :name, :ask, :change, :change_in_percent, :market_capitalization])
  end

  def new
    @company = Company.new
  end

  def edit
    @company = current_user
    @url = ArmorPaymentsApi.select_payout_preference(current_user)
  end

  def confirm_email
    company = Company.find_by(confirm_token: params[:format])
    if company
      company.email_activate
      armor_ids = ArmorPaymentsApi.create_account(company)
      company.update_attribute('armor_account_id', armor_ids[:armor_account_number])
      company.update_attribute('armor_user_id', armor_ids[:armor_user_number])
      redirect_to login_path, notice: 'Welcome to bid.aero, your email has been confirmed'
    else
      redirect_to root_path, notice: 'Sorry, company does not exist'
    end
  end

  def create
    @company = Company.new(company_params)
    respond_to do |format|
      if @company.save
          ## need to make validations so that errors are note received from armor payments (testing purposes)
        CompanyMailer.registration_confirm(@company).deliver
        # session[:company_id] = @company.id
        format.html { redirect_to root_path, notice: 'Please confirm your email address to complete registration.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to home_path, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

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

    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(:name, :armor_account_id, :armor_user_id, :email, :EIN, :password, :password_confirmation, :representative, :phone, :address, :city, :state, :zip, :country)
    end
end
