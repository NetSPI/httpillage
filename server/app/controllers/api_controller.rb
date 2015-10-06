class ApiController < ActionController::Base
	def authorized?
    # Check if header matches
    raise unless current_user
  end

  def authorized_node?
    raise unless Setting.find_by_key("nodeApi").val == request.headers['X-Node-Token']
  end

  private
  def current_user
    User.from_api_token(request.headers['X-Auth-Token'])
  end
end