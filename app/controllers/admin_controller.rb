class AdminController < ApplicationController
	before_action :check_system_admin

	def super_index
		render_view(AllInventoryDatatable.new(view_context))
	end

	def matched_auctions
		render_view(MatchedAuctionsDatatable.new(view_context))
	end
	 
	def unmatched_auctions
		render_view(UnmatchedAuctionsDatatable.new(view_context))
	end

	def all_auctions
		render_view(AllAuctionsDatatable.new(view_context))
	end
	
	private

	def check_system_admin
		redirect_to dashboard_path unless current_user.system_admin?
	end

	def render_view(dataTable)
		if current_user.system_admin?
		  respond_to do |format|
			format.html
			format.json { render json: dataTable }
		  end
		end
	end
end
