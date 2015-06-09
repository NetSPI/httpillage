class JobController < ApiController
	def index
		@jobs = Job.all
	end

	def destroy
		Job.find(params[:jobid]).destroy
		redirect_to action: "index"
	end
end