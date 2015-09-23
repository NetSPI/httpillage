require 'base64'

class JobController < ApplicationController
	helper Bruteforce
	def index
		@jobs = Job.all
	end

	def show
		@job = Job.find(params[:jobid])
		@node_statuses = @job.node_status_checkins.limit(5)

		if @job.attack_type == "bruteforce"
			@charset = @job.charset

			# keyspace
			jobKeyspace = Bruteforce::generateSubkeyspace(@job.charset, @job.next_index, 300)

			@keyspace_start_val = jobKeyspace[0]
			@keyspace_end_val = jobKeyspace[-1]

			@bruteforce_status = @job.next_index
			@keyspace_size = Bruteforce::totalSize(@charset)

			@bruteforce_percentage = (@bruteforce_status.to_f / @keyspace_size.to_f * 100.0).to_i
		end
	end

	def new
		@job ||= Job.new
		@dictionaries ||= Dictionary.all
	end

	def create
		@job = Job.new(job_params)

		@job.user_id = current_user.id

		@job.http_headers = Base64.encode64(@job.http_headers)
		@job.http_data = Base64.encode64(@job.http_data)
		@job.save

		if @job.valid?
			flash[:notice] = "Job created successfully"
		else
			flash[:error] = @job.errors
		end

		redirect_to jobs_path
	end

	def edit
		@job = Job.find(params[:jobid])
		@dictionaries ||= Dictionary.all

		# Decode headers, data, etc....
		@job.http_headers = Base64.decode64(@job.http_headers)
		@job.http_data = Base64.decode64(@job.http_data)
	end

	def update
		@job = Job.find(params[:jobid])
		@job.update_attributes(job_params)
		@job.http_headers = Base64.encode64(@job.http_headers)
		@job.http_data = Base64.encode64(@job.http_data)

		if @job.save!
			flash[:notice] = "Job #{@job.id} updated successfully"
      redirect_to show_job_path(@job)
		else
			flash[:alert] = @job.errors.full_messages.join("\n")
      redirect_to jobs_path(@user)
		end
	end

	def destroy
		Job.find(params[:jobid]).destroy
		redirect_to action: "index"
	end

	private
	def job_params
		params.require(:job).permit(
			:description,
			:http_method, 
			:http_uri, 
			:http_headers, 
			:http_data, 
			:attack_type, 
			:attack_mode,
			:status,
			:dictionary_id,
			:charset)
	end
end