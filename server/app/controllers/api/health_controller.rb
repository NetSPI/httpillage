class Api::HealthController < ApiController
	def index
		render :json => true
	end
end