class SessionController < ApplicationController
  skip_before_action :require_logged_in

  def new
    redirect_to current_user if current_user
  end

  def create
    @company = Company.find_by_email(params[:login][:email]).try(:authenticate, params[:login][:password])
    if @company
      session[:company_id] = @company.id
      redirect_to @company
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
end
