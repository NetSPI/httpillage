class JobController < ApiController
	def index
		@jobs = Job.all
	end

	def new
		@job ||= Job.new
	end

	def create
		@job = Job.create(job_params)

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
		params.require(:job).permit(:http_method, :http_uri, :http_headers, :http_data, :attack_type, :job_status)
	end
end