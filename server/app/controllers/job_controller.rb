require 'base64'

class JobController < ApplicationController
	def index
		@jobs = Job.all
	end

	def show
		@job = Job.find(params[:jobid])
	end

	def new
		@job ||= Job.new
		@dictionaries ||= Dictionary.all
	end

	def create
		@job = Job.new(job_params)

		@job.http_headers = Base64.encode64(@job.http_headers)
		@job.http_data = Base64.encode64(@job.http_data)
		@job.save

		if @job.valid?
			render :json => @job.to_json
		else
			render :json => @job.errors.messages.to_json
		end
	end

	def destroy
		Job.find(params[:jobid]).destroy
		redirect_to action: "index"
	end

	private
	def job_params
		params.require(:job).permit(
			:http_method, 
			:http_uri, 
			:http_headers, 
			:http_data, 
			:attack_type, 
			:attack_mode,
			:status,
			:dictionary_id)
	end
end