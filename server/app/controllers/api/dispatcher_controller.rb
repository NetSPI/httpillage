class Api::DispatcherController < ApiController
	# 
	# When polling check to see if there have been any updates
	# to the current job.
	#
	def poll
		node_id = params[:nodeid] ? params[:nodeid] : create_node
		active_node = Node.find(node_id)

		if params[:jobid]
			# check status of current job
			job = Job.find(params[:jobid])

			if job.status == "active"
				render :json => '{ "status": "active"}'
			else
				render	:json => '{ "status": "halt"}'
			end
		else
			# check if there are any ongoing jobs
			jobs = Job.active

			# If there are any, choose one randomly
			if jobs.count > 0
				job_idx = rand(jobs.count - 1)

				# TODO: Make this return node_id too
				render :json => jobs[job_idx].to_json
			else
				render :json => '{ "job": "none"}'
			end
		end

		# mark the client as active
		active_node.mark_active
	end

	def create_node
		node = Node.new
		node.ip_addr = request.env["HTTP_X_FORWARDED_FOR"]
		node.last_seen = DateTime.now
		node.save

		return node
	end
end