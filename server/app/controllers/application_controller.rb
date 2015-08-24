class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
  before_filter :update_time_to_prevent_caching
  before_filter :authenticate_user!

  def update_time_to_prevent_caching
    headers['Last-Modified'] = Time.now.httpdate
  end  
end
