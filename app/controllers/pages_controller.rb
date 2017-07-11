class PagesController < ApplicationController
	skip_before_action :require_logged_in
	before_action :send_mail, except: [:new_lead, :sign_up_form]
	layout 'landing'

	def show
		redirect_to dashboard_path if current_user
	end

	def about
		@about = true
	end

	def pricing
		redirect_to dashboard_path if current_user
	end

	def features
		redirect_to dashboard_path if current_user
	end

	def aircraft_listing
		@aircrafts = Aircraft.all
	end

	def aircraft_show
		@aircraft = Aircraft.find(params[:id])
	end

	def engine_listings
		@engines = Engine.all
	end

	def engine_show
		@engine = Engine.find(params[:id])
	end

	def privacy_policy
	end

	def terms_and_conditions
	end

	def inventory_part
		@part_count = InventoryPart.where(part_num: params[:part_num]).count
		@part = InventoryPart.find_by(part_num: params[:part_num])
	end

	def sign_up_form
		# not the best way to do this, must refactor at a later time
		new_lead_mail if params[:contact]
	end

	def sitemap
		respond_to do |format|
			format.xml
		end
	end

	def sitemap_index
		respond_to do |format|
			format.xml
		end
	end


	private

	def new_lead_mail
		AdminMailer.new_lead(params[:contact], params[:company], params[:phone], params[:email], params[:message], params[:subject]).deliver_now
	end

	def send_mail
		AdminMailer.new_contact(params[:name], params[:phone], params[:email], params[:message]).deliver_now if params[:name]
	end

	def send_mail
		AdminMailer.new_contact_autoreply(params[:name], params[:phone], params[:email], params[:message]).deliver_now if params[:name]
	end
end
