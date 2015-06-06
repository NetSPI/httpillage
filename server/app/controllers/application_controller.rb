class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_filter	:authorized?
  before_filter :update_time_to_prevent_caching

  def update_time_to_prevent_caching
    headers['Last-Modified'] = Time.now.httpdate
  end

  def authorized?
  	# Check if header matches
  	raise unless request.headers['X-Auth-Token'] == "gsYr4l70l08bcr77cZJMGrBUMYqhQlnR8KrqZWbI3ehH39OX8qb1hK2EcxkW"
  end
  
end
