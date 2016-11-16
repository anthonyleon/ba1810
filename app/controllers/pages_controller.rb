class PagesController < ApplicationController
  skip_before_action :require_logged_in

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

end