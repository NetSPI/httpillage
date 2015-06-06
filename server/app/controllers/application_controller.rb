class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_filter :update_time_to_prevent_caching

  def update_time_to_prevent_caching
    headers['Last-Modified'] = Time.now.httpdate
  end
  
end
