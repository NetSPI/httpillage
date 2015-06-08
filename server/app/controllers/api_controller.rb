class ApiController < ActionController::Base
	private
	def authorized?
  	# Check if header matches
  	raise unless request.headers['X-Auth-Token'] == "gsYr4l70l08bcr77cZJMGrBUMYqhQlnR8KrqZWbI3ehH39OX8qb1hK2EcxkW"
  	end
end