class ApiController < ActionController::Base
	private

  def current_user
    User.from_api_token(request.headers['X-Auth-Token'])
  end

	def authorized?
  	# Check if header matches
  	raise unless current_user
  end
end