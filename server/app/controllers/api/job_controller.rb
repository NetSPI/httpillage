class Api::JobController < ApiController
	before_filter	:authorized?

	#
	# Burp will point to this endpoint when creating new jobs
	#
	def create
		job = Job.new
		job.http_method 	= params[:http_method]
		job.http_uri 		= params[:http_uri]
		job.http_host 		= params[:http_host]
		job.http_headers	= params[:http_headers]
		job.http_data		= params[:http_data]

		# Set job type to bruteforce by default. This will change, but
		# for now we don't care about responses.
		job.attack_type			= "repeat"

		# Set status to active by default -- this may change in future
		job.status 			= "active"

		job.save

		render :json => job.to_json
	end
end