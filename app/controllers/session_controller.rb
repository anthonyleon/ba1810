class SessionController < ApplicationController
	skip_before_action :require_logged_in


	def new
		redirect_to dashboard_path if current_user
	end

	def create
		@company = Company.find_by_email(params[:login][:email].downcase.squish).try(:authenticate, params[:login][:password])
		if !@company
			redirect_to login_path, flash: { error: "Username or Password is invalid" }
		elsif @company.email_confirmed
			session[:company_id] = @company.id
			#flash.now[:notice] = "Welcome #{@company.name}"
			#flash.keep
			redirect_to dashboard_path, flash: { success: "Successfully logging in #{@company.name}" }
		else !@company.email_confirmed
			redirect_to login_path, flash: {warning: "Please check your e-mail for a confirmation link"}
		end
	end

	def temp_login
		@auction = Auction.find_by(@auction_id)
		token = params[:company][:token]
		password = params[:company][:password]
		password_confirm = params[:company][:password_confirmation]
		@auction_id = params[:company][:auction_id]
		if params[:company][:password].length < 8
			redirect_to invited_supplier_setup_path(@auction_id, format: token), flash: { error: "Password must be at least 8 characters long" }
		elsif password != password_confirm
			redirect_to invited_supplier_setup_path(@auction_id, format: token), flash: { error: "Password Confirmation does not match Password" }
		elsif !(Company.find_by_email(params[:company][:email].downcase.squish)) #.try(:authenticate, token))
			redirect_to invited_supplier_setup_path(@auction_id, format: token), flash: { error: "Invalid E-mail" }
		else
			@company = Company.find_by_email(params[:company][:email].downcase.squish) #if I feel the need that the passwords password entered should match the old password .try(:authenticate, token)
			session[:company_id] = @company.id
			@company.update_attribute('password', password)
			redirect_to auction_path(@auction_id), flash: { success: "Welcome #{@company.name}!" }
		end
	end

	def invited_supplier_setup
		redirect_to dashboard_path if current_user
		@auction_id = params[:auction_id]
		@auction = Auction.find(params[:auction_id])
		@token = params[:format]
		@company = Company.find_by(confirm_token: @token)

	end

	def destroy
		reset_session
		redirect_to root_path
	end
end
