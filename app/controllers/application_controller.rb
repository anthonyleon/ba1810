class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :require_logged_in

  def current_user
    @current_user ||= Company.find_by(id: session[:company_id])
  end

  def require_logged_in
    redirect_to root_path unless current_user
  end


end
