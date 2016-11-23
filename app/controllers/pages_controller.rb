class PagesController < ApplicationController
  skip_before_action :require_logged_in

  layout 'landing'

  def show
  	redirect_to dashboard_path if current_user
    AdminMailer.new_contact(params[:name], params[:phone], params[:email], params[:message]).deliver_now if params[:name]
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

  def engine_listing
    @engines = Engine.all
  end

  def engine_show
    @engine = Engine.find(params[:id])
  end

end
