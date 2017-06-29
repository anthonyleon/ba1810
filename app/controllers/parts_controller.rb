class PartsController < ApplicationController
  
  def import
  	@import = Part.import(params[:file])
  	redirect_to parts_path
  end

  def new
  	redirect_to dashboard_path unless current_user.system_admin?
  end

  def index
    redirect_to dashboard_path unless current_user.system_admin?
  	@parts = Part.all
  end

end
