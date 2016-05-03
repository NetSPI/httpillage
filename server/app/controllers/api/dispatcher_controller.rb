class Api::DispatcherController < ApiController
	before_filter	:authorized_node?
	# 
	# When polling check to see if there have been any updates
	# to the current job.
	#
	def poll
		active_node = Node.find_by_mac_address(params[:nodeid]) || create_node

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
			job = get_active_job(active_node.id)

			# If there are any, choose one randomly
			unless job.nil?

				# If it's a dictionary job let's find the work
				if job[:attack_type] == "dictionary"
					# Not elegant, but can't directly assign job[:work] = ...
					job.work = dictionary_content_for_job(job.id, active_node.id)

					if job.work == ""
						job.status = "completed"
						job.save
						return :json => '{ "status": "halt"}'
					end
				elsif job[:attack_type] == "bruteforce"
					job.next_index = job.next_index.nil? ? 0 : job.next_index
					Bruteforce::initiateKeyspaceDict()

					bruteforce_status = BruteforceStatus.create({
						:node_id => active_node.id,
						:job_id => job.id,
						:index => job.next_index
					})
					## Calculate next index. We're just going to increase by 50 for now
					job.next_index = job.next_index + 50
					job.save

					# TODO: Mark job complete if next_index > length
					# TODO: This is a bug
					keyspace_size = Bruteforce::totalSize(job.charset)
					if job.next_index > keyspace_size
						job.status = "completed"
						job.save
					end

				end

				render :json => job, methods: [:work, :response_flag_meta]
			else
				render :json => '{ "job": "none"}'
			end
		end

		# mark the client as active
		active_node.mark_active
	end

	def checkin

		# Test this code in the morning
		status_code = params[:status_code]
		node = Node.find_by_mac_address(params[:nodeid])

		checkin = NodeStatusCheckin.create({
				:node_id				=> node.id,
				:job_id 				=> params[:jobid],
				:response_code 	=> status_code
		})

		# Check in to provide an update for a particular job

		return poll
	end

	#
	# This function is responsible for managing the dictionary content allocation for jobs.
	# Each job allocation will include 100 dictionary items for the
	#
	def dictionary_content_for_job(job_id, node_id)
		# check if there is any progress on current job, if not, starts
		next_byte_start_for_job = DictionaryChunkAllocation.nextChunkForJob(job_id)

		active_job = Job.find(job_id)
		used_dictionary = active_job.dictionary
		file_info = content_from_dictionary_file(used_dictionary.filename, next_byte_start_for_job)

		content = file_info[:content]

		# Update in database -- this may have a race condition.
		chunk = DictionaryChunkAllocation.create({
			:job_id 		=> job_id,
			:node_id		=> node_id,
			:start_byte 	=> next_byte_start_for_job,
			:end_byte		=> (file_info[:new_byte_marker] - 1),
			:completed		=> false	## Need to actually check
		})

		return content
	end

	# this should be moved to a helper function
	def content_from_dictionary_file(dictionary, start_byte, byte_increment=1024)
		# Make sure values are actually integers to prevent command injection
		start_byte = start_byte.to_i
		byte_increment = byte_increment.to_i
		return_lines = `tail -c +#{start_byte} #{find_path_to_dictionary(dictionary)} | head -c #{byte_increment}`

		# Figure out where last newline is, chop that off (including straggling data)
		# update current byte counter to reflect new, modified size.
		# This is to ensure we're parsing all of the data, even if a line is chopped.
		adjusted_return_lines = return_lines.gsub(/\n(.*)\Z/, "")

		adjusted_byte_size = adjusted_return_lines.bytesize
		adjusted_position_marker = start_byte + adjusted_byte_size

		return { :content => adjusted_return_lines, :new_byte_marker => adjusted_position_marker}
	end

	def find_path_to_dictionary(dictionary)
		return Rails.root.join("lib", "dictionaries", dictionary)
	end

	def create_node
		node 				= Node.new
		node.ip_addr 		= request.remote_ip
		node.mac_address 	= params[:nodeid]
		node.last_seen 		= DateTime.now
		node.save

		return node
	end

	def get_active_job(node_id)
		jobs = Job.active

		jobs.each do |job|
			# Check if job has node_limit, if so, ensure it's not too high
			node_checkins = NodeStatusCheckin.where("node_id != ?", node_id).checkins_since_timestamp(job.id, 5.minutes.ago.to_s).map(&:node_id).uniq

			if ! job.node_limit.nil? && node_checkins.count > job.node_limit
				next
			else
				return job
			end
		end

		return nil
	end
end