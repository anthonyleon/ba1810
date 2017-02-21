class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :require_logged_in, except: [:find_states]
  # before_action :check_browser
  force_ssl if: :ssl_configured?

  def ssl_configured?
    !Rails.env.development?
  end
  
  def current_user
    @current_user ||= Company.find_by(id: session[:company_id])
  end

  def require_logged_in
    redirect_to root_path unless current_user
  end

  private
    Browser = Struct.new(:browser, :version)

    SupportedBrowsers = [
      Browser.new("Safari", "3.1.1"),
      Browser.new("Firefox", "2.0.0.14"),
      Browser.new("Internet Explorer", "10.0"),
      Browser.new('Chrome', '60')
    ]
    def check_browser
      user_agent = UserAgent.parse(request.user_agent)
      unless SupportedBrowsers.detect { |browser| user_agent >= browser }
        if current_user
          session[:company_id] = nil
          redirect_to root_path
          return
        end
          render layout: 'browser_not_support'
          return
      end
    end
end
