class PasswordResetsController < ApplicationController
  skip_before_action :require_logged_in
  
  def new
  end

  def create
  	user = Company.find_by(email: params[:email])
  	user.send_password_reset if user
  	redirect_to root_url, :notice => "E-Mail sent with password reset instructions."
  end

  def edit
  	@company = Company.find_by_password_reset_token!(params[:id]) #.find_by(password_reset_token: params[:id])
  end

  def update
  	@company = Company.find_by_password_reset_token!(params[:id])
  	if @company.password_reset_sent_at < 2.hours.ago
  		redirect_to new_password_reset_path, :alert => "Password reset has expired."
  	elsif @company.update_attributes(params[:user])
  		redirect_to root_url, :notice => "Password has been reset!"
  	else
  		render :edit
  	end  		
  end
end
