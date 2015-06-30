class Api::DispatcherController < ApiController
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
			jobs = Job.active

			# If there are any, choose one randomly
			if jobs.count > 0
				job_idx = rand(jobs.count - 1)

				job = jobs[job_idx]

				# If it's a dictionary job let's find the work
				if job[:attack_type] == "dictionary"
					# Not elegant, but can't directly assign job[:work] = ...
					job.work = dictionary_content_for_job(job.id, active_node.id)
				end

				# TODO: Make this return node_id too
				render :json => job, methods: [:work]
			else
				render :json => '{ "job": "none"}'
			end
		end

		# mark the client as active
		active_node.mark_active
	end

	def test
		render :json => dictionary_content_for_job(1, 3).to_json
	end

	#
	# This function is responsible for managing the dictionary content allocation for jobs.
	# Each job allocation will include 100 dictionary items for the
	#
	def dictionary_content_for_job(job_id, node_id)
		# check if there is any progress on current job, if not, starts
		next_byte_start_for_job = DictionaryChunkAllocation.nextChunkForJob(job_id)

		# Total count: 153004874
		file_info = content_from_dictionary_file("500worstpasswords", next_byte_start_for_job)

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
		valid_dictionaries = { "rockyou" => "rockyou.txt", "500worstpasswords" => "500-worst-passwords.txt"}

		dictionary_file = valid_dictionaries[dictionary]

		return Rails.root.join("lib", "dictionaries", dictionary_file)
	end

	def create_node
		node 				= Node.new
		node.ip_addr 		= request.remote_ip
		node.mac_address 	= params[:nodeid]
		node.last_seen 		= DateTime.now
		node.save

		return node
	end
end