class PartsController < ApplicationController
  
  def import
  	@import = Part.import(params[:file])
  	redirect_to parts_path
  end

  def new
  	redirect_to dashboard_path unless current_user.email == "support@bid.aero" || current_user.email == "general@gaylord.io"
  end

  def index
    redirect_to dashboard_path unless current_user.email == "support@bid.aero" || current_user.email == "general@gaylord.io"
  	@parts = Part.all
  end

end
