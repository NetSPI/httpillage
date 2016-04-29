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

			Bruteforce::initiateKeyspaceDict()

			# keyspace
			jobKeyspace = Bruteforce::generateSubkeyspace(@job.charset, @job.next_index, 50)

			unless jobKeyspace.nil?
				@keyspace_start_val = jobKeyspace[0]
				@keyspace_end_val = jobKeyspace[-1]

				@bruteforce_status = @job.next_index
				@keyspace_size = Bruteforce::totalSize(@charset)

				@bruteforce_percentage = ((@bruteforce_status.to_f / @keyspace_size.to_f * 100.0).to_i).to_s + "%"
			else
				@bruteforce_percentage = "N/A"
			end
		end
	end

	def new
		@job ||= Job.new
		@dictionaries ||= Dictionary.all
	end

	def create
		@job = Job.new(job_params)

		@job.user_id = current_user.id

		@job.http_headers = @job.http_headers
		@job.http_data = @job.http_data
		@job.save


		# Create response flag meta information for job
		if params[:job][:response_flag_meta]
			params[:job][:response_flag_meta].each_with_index do |rfm|
				# TODO: Fix this weird hackery... not sure why params are being passed in weirdly
				rfm = rfm[1]

				# Ignore if the string is empty
				if rfm[:match_value] != ""

					flag_meta = ResponseFlagMeta.new
					flag_meta.job_id = @job.id
					flag_meta.match_value = rfm[:match_value]
					flag_meta.match_type = rfm[:match_type]
					flag_meta.match_delivery = rfm[:match_delivery]
					flag_meta.save
				end
			end
		end

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
		@job.http_headers = @job.http_headers
		@job.http_data = @job.http_data
	end

	def update
		@job = Job.find(params[:jobid])
		@job.update_attributes(job_params)
		@job.http_headers = @job.http_headers
		@job.http_data = @job.http_data

		# Update the Response Flags

		if params[:job][:response_flag_meta]
			params[:job][:response_flag_meta].each_with_index do |rfm|
				# TODO: Fix this weird hackery... not sure why params are being passed in weirdly
				rfm = rfm[1]

				# If it has an id, update, otherwise create
				if rfm["id"] != nil
					flag_meta = ResponseFlagMeta.find(rfm["id"])
				else
					flag_meta = ResponseFlagMeta.new
				end
				flag_meta.job_id = @job.id
				flag_meta.match_value = rfm[:match_value]
				flag_meta.match_type = rfm[:match_type]
				flag_meta.match_delivery = rfm[:match_delivery]
				flag_meta.save
			end
		end

		if @job.save!
			flash[:notice] = "Job #{@job.id} updated successfully"
      redirect_to show_job_path(@job)
		else
			flash[:alert] = @job.errors.full_messages.join("\n")
      redirect_to jobs_path(@user)
		end
	end

	def start
		@job = Job.find(params[:jobid])
		@job.status = "active"
		@job.save

		flash[:notice] = "Job #{@job.id} started"
		redirect_to action: "index"
	end

	def stop
		@job = Job.find(params[:jobid])
		@job.status = "pending"
		@job.save

		flash[:notice] = "Job #{@job.id} stopped"
		redirect_to action: "index"
	end

	def destroy
		Job.find(params[:jobid]).destroy

		flash[:notice] = "Job #{params[:jobid]} destroyed"
		redirect_to action: "index"
	end

	# For API Call
	def bruteforce_progress
		job = Job.find(params[:jobid])
		Bruteforce::initiateKeyspaceDict()

		begin
			jobKeyspace = Bruteforce::generateSubkeyspace(job.charset, job.next_index, 50)

			keyspace_start_val = jobKeyspace[0]
			keyspace_end_val = jobKeyspace[-1]

			bruteforce_status = job.next_index
			keyspace_size = Bruteforce::totalSize(job.charset)

			progress_percentage = (bruteforce_status.to_f / keyspace_size.to_f * 100.0).to_i
		
			render :json => { 
				"keyspace_start" 	=> keyspace_start_val,
				"keyspace_end" 		=> keyspace_end_val,
				"keyspace_progress" => progress_percentage + "%"
			}
		rescue Exception => e
			render :json => { 
				"keyspace_start" 	=> "N/A",
				"keyspace_end" 		=> "N/A",
				"keyspace_progress" => "N/A"
			}
		end
	end

	def checkins_since_timestamp
		new_checkins = NodeStatusCheckin.checkins_since_timestamp(params[:jobid], params[:timestamp])

		render :json => { :newTimestamp => DateTime.now.utc, :checkins => new_checkins }
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
			:node_limit,
			:charset)
	end
end