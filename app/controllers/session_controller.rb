class SessionController < ApplicationController
  skip_before_action :require_logged_in

  def new
    redirect_to company_path(session[:company_id]) if current_user
  end

  def create
    @company = Company.find_by_email(params[:login][:email]).try(:authenticate, params[:login][:password])
    if @company
      session[:company_id] = @company.id
      redirect_to @company
    else
      redirect_to root_path, notice: "Wrong credentials"
    end
  end

  def destroy
    session[:company_id] = nil
    redirect_to root_path
  end
end
