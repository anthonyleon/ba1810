class SessionController < ApplicationController
  skip_before_action :require_logged_in


  def new
    redirect_to dashboard_path if current_user
  end

  def create
    @company = Company.find_by_email(params[:login][:email].downcase).try(:authenticate, params[:login][:password])
    if !@company
      redirect_to login_path, flash: { error: "Username or Password is invalid" }
    elsif @company.email_confirmed
      session[:company_id] = @company.id
      #flash.now[:notice] = "Welcome #{@company.name}"
      #flash.keep
      redirect_to dashboard_path, flash: { success: "Successfully logging in #{@company.name}" }
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
    else !@company.email_confirmed
      redirect_to login_path, flash: {warning: "Please check your e-mail for a confirmation link"}
    end
  end

  def destroy
    session[:company_id] = nil
    redirect_to root_path
  end
end
