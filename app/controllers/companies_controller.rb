require 'httparty'
require 'nokogiri'
require 'yahoo-finance'

class CompaniesController < ApplicationController

  before_action :set_company, only: [:update, :destroy]
  skip_before_action :require_logged_in, only: [:new, :create, :confirm_email]

  # before_action :set_armor_client, only: [:create, :edit, :update, :sales, :purchases]

  def show
    yahoo_client = YahooFinance::Client.new
    @data = yahoo_client.quotes(["AER", "AYR", "FLY", "AL", "ACY", "WLFC"], [:symbol, :name, :ask, :change, :change_in_percent, :market_capitalization])
  end

  def new
    redirect_to dashboard_path if current_user
    @company = Company.new
  end

  def edit
    @url = ArmorPaymentsApi.select_payout_preference(current_user)
    @company = current_user
    @company_doc = CompanyDoc.new 
    @company_docs = current_user.company_docs
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

  def create
    @company = Company.new(company_params)
    respond_to do |format|
      if @company.save
          ## need to make validations so that errors are not received from armor payments (testing purposes)
        AdminMailer.new_register(@company).deliver
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
      if @company.update(company_params) || @company.edit_attrs(company_params)
        format.html { redirect_to dashboard_path, notice: 'Company was successfully updated.' }
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

  def choose_payout_preference
    @url = ArmorPaymentsApi.select_payout_preference(current_user)
  end

  def sales
    @sales = Transaction.where(seller_id: current_user.id, complete: true)
  end

  def pending_sales
    @sales = Transaction.where(seller_id: current_user.id, complete: false)
  end

  def purchases
    @purchases = Transaction.where(buyer_id: current_user.id, complete: true)
  end

  def pending_purchases
    @purchases = Transaction.where(buyer_id: current_user.id, complete: false)
  end

  def admin_inventory_upload
    redirect_to dashboard_path unless current_user.system_admin? 
  end

  private

    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(:name, :armor_account_id, :armor_user_id, :email, :ein, :password, 
        :password_confirmation, :representative, :phone, :address, :city, :state, :zip, :country, 
        :inc_country, :inc_state, :business_type, :url)
    end
end
