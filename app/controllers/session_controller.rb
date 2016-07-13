class SessionController < ApplicationController
  skip_before_action :require_logged_in

  def new
    redirect_to home_path if current_user
  end

  def create
    @company = Company.find_by_email(params[:login][:email].downcase).try(:authenticate, params[:login][:password])
    if @company
      session[:company_id] = @company.id
      redirect_to home_path
      # if !@company.armor_account_id
      #   @company.update(company_params)
      #   set_armor_client
      #   armor_create
      #   p result = @client.accounts.create(@account_data)
      #   p armor_account_num = result.data[:body]["account_id"]

      #   ## Company armor_user_id
      #   p users = @client.accounts.users(armor_account_num).all
      #   @company.update(armor_account_id: armor_account_num, armor_user_id: users.data[:body][0]["user_id"])
      # end

      # if @company.email_confirmed
      #   session[:company_id] = @company.id
      #   redirect_to @company
      # else
      #   flash.now[:error] = "Please confirm your email by clicking the link sent to your email address"
      #   render :new
      # end
    else
      redirect_to root_path, notice: "Wrong credentials"
    end
  end

  def destroy
    session[:company_id] = nil
    redirect_to root_path
  end

  # private
  #   def set_armor_client
  #     @client = ArmorPayments::API.new( ENV['ARMOR_PKEY'], ENV['ARMOR_SKEY'], true)
  #   end

  #   def armor_create
  #     @account_data = {     
  #       "company": @company.name,
  #       "user_name": @company.representative,
  #       "user_email": @company.email,
  #       "user_phone": "+1 #{@company.phone.gsub('-', '')}",
  #       "address": @company.address,
  #       "city": @company.city,
  #       "state": @company.state,
  #       "zip": @company.zip,
  #       "country": @company.country,
  #       "email_confirmed": true, 
  #       "agreed_terms": true 
  #       }
  #   end

  #   def company_params
  #     params.require(:company).permit(:armor_account_id, :armor_user_id)
  #   end
end
