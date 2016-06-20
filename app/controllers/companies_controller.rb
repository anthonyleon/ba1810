class CompaniesController < ApplicationController
  require 'httparty'
  require 'nokogiri'

  before_action :set_company, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_logged_in, only: [:new, :create, :confirm_email]
  before_action :set_armor_client, only: [:create, :show]

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
    @inactive_auctions = current_user.auctions.where(active: false)

    aer_ap = HTTParty.get('https://finance.yahoo.com/q?uhb=uh3_finance_vert&fr=&type=2button&s=AER%2C')
    air_castle = HTTParty.get('http://finance.yahoo.com/q?s=AYR')
    fly_leasing = HTTParty.get('http://finance.yahoo.com/q?s=FLY')
    aero_century = HTTParty.get('http://finance.yahoo.com/q?s=ACY')
    al_air_lease = HTTParty.get("http://finance.yahoo.com/q?s=AL")

    aer_ap_parsed_response = Nokogiri::HTML(aer_ap)
    air_castle_parsed_response = Nokogiri::HTML(air_castle)
    fly_leasing_parsed_response = Nokogiri::HTML(fly_leasing)
    aero_century_parsed_response = Nokogiri::HTML(aero_century)
    al_air_lease_parsed_response = Nokogiri::HTML(al_air_lease)

    @data = {}
    def render_data(source, data, symbol)
      source.css("#yfi_rt_quote_summary").map do |resp|
        @data["#{data}"] = {
          name: resp.css('div .title').text,
          price: resp.css("#yfs_l84_#{symbol}").text,
          change: resp.css("#yfs_c63_#{symbol}").text,
          change_in_percentage: resp.css("#yfs_p43_#{symbol}").text,
          mkt_cap: resp.css("#yfs_c63_#{symbol}").text
        }
      end
    end

    render_data(aer_ap_parsed_response, "aer_ap_data", "aer")
    render_data(air_castle_parsed_response, "air_castle_data", "ayr")
    render_data(fly_leasing_parsed_response, "fly_leasing_data", "fly")
    render_data(al_air_lease_parsed_response, "al_air_lease_data", "al")
    render_data(aero_century_parsed_response, "aero_centur_data", "acy")
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
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
        armor_create
        p result = @client.accounts.create(@account_data)
        p armor_account_num = result.data[:body]["account_id"].to_s
        @company.update(armor_account_id: armor_account_num)

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
            possible_auctions << auct_part.auction if auct_part.auction.active == true
          end
        end
      end
      possible_auctions
    end

    def set_armor_client
      @client = ArmorPayments::API.new('71634fba00bd805fba58cce92b394ee8', '9bf2dcb9214a2b25af659f1506c63ff4ee6cce28f2f1f754ad3a8288bcb06eb5', true)
    end

    def armor_create
      @account_data = {     
        "company": @company.name,
        "user_name": @company.representative,
        "user_email": @company.email,
        "user_phone": "+1 #{@company.phone.gsub('-', '')}",
        "address": @company.address,
        "city": @company.city,
        "state": @company.state,
        "zip": @company.zip,
        "country": @company.country,
        "email_confirmed": true, 
        "agreed_terms": true 
        }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :armor_id, :armor_user_id, :email, :EIN, :password, :password_confirmation, :representative, :phone, :address, :city, :state, :zip, :country)
    end
end
