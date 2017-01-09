class PagesController < ApplicationController
  skip_before_action :require_logged_in
  before_action :send_mail

  layout 'landing'

  def show
  	redirect_to dashboard_path if current_user
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

  def engine_listing
    @engines = Engine.all
  end

  def engine_show
    @engine = Engine.find(params[:id])
  end

  def privacy_policy
  end

  def terms_and_conditions
  end

  private 

  def send_mail
    AdminMailer.new_contact(params[:name], params[:phone], params[:email], params[:message]).deliver_now if params[:name]    
  end


end
