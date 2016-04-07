class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

  # Security Headers
  before_filter :csp
  before_filter :xframe_options

  before_filter :update_time_to_prevent_caching


  before_filter :authenticate_user!

  helper_method :version

  def csp
    headers['Content-Security-Policy'] = "script-src 'self'; style-src 'self' http://fonts.googleapis.com"
  end

  def xframe_options
    headers['X-Frame-Options'] = "DENY"
  end

  def update_time_to_prevent_caching
    headers['Last-Modified'] = Time.now.httpdate
  end  

  private
  def require_admin
    unless current_user.admin?
      flash[:alert] = "Page requires admin account"
      redirect_to root_path
    end
  end

  def version
    version = File.read('config/version')
    if Rails.env.development?
      version += " (Branch: #{`git rev-parse --abbrev-ref HEAD`}, Commit: #{`git rev-parse --short HEAD`})"
    end
    version
  end
end
