# encoding: utf-8
require './bruteforce.rb'

SLEEP_TIME = 3

class Client
	def initialize(server, thread_count, proxy_host, proxy_port, api_key, cert_path)
		@server = server + "/api"
		@proxy_host = proxy_host
		@proxy_port = proxy_port
		@has_job = false
		@thread_count = thread_count
		@node_api_key = api_key

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
		@charset = "" 
		@last_status_code = 0

		@response_flag_meta = []

		# This var is only used when performing dictionary attacks
		# It will be populated by the server
		@attack_payloads = []

		@cert_path = cert_path

	end

	def invoke
		# Make sure we can reach C&C
		cc_server_reachable = false
		while cc_server_reachable == false
			cc_server_reachable = cc_stability_test
		end

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
		@http_header_string = job["http_headers"]
		@http_headers 		= parse_headers(@http_header_string)
		@http_data_string = job["http_data"]
		@http_data 				= parse_data(job["http_data"])

		@bruteforce_index = job["next_index"]
		if @job_type == "dictionary"
			@attack_payloads 	= parse_work(job["work"])
		elsif @job_type == "bruteforce"
			@charset = job["charset"]
			@attack_payloads = generateSubkeyspace(@charset, @bruteforce_index, 50)
		end

		@response_flag_meta = job["response_flag_meta"]


		puts "Work: #{@attack_payloads}"
		kick_off_job!
	end

	def request_job
		endpoint = @server + "/poll/#{@node_id}"

		headers = get_auth_headers
		puts "Requesting Job"

		req = Mechanize.new.tap do |r|
				if @server.match(/^https/)  # enable SSL/TLS
				  r.agent.ca_file = @cert_path
				end
			end

		begin
			response = req.get(endpoint, {}, nil, headers)
		rescue Exception => e
			puts e.inspect
		end

		# Parse response

		unless response.nil? || response.body.nil?
			response_parsed = JSON.parse(response.body)
		
			if response_parsed["status"] == "active"
				return response_parsed
			end
		end
		# Failed, but let's sleep
		puts "Sleeping for #{SLEEP_TIME} seconds"
		sleep(SLEEP_TIME)
		return false
	end

	def kick_off_job!
		puts "(+) Job recieved. Kicking it off with #{@thread_count} threads"
		puts "(+) Currently attacking: #{@http_uri}"
		monitor_thread_id = @thread_count.to_i + 1

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
						res = process_request

						if res == "done"
							@has_job = false
						end
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
		# If it's repeat, there are no payloads... otherwise process
		if @job_type == "repeat"
			send_request
		elsif @job_type == "dictionary" || @job_type == "bruteforce"
			payload = @attack_payloads.pop

			if payload == ""
				payload = @attack_payloads.pop
			end

			if payload.nil? 
				# No more work to do..mark job as complete
				@has_job = false
				return "done"
			end

			# In this iteration we simply replace all payload markers with the
			# same payload value. This will likely change, allowing users to
			# specify different payloads and modes, similar to Burp's intruder.
			attack_uri = @http_uri.gsub("{P}", payload)

			attack_data = parse_data(@http_data_string.gsub("{P}", payload))

			payload_headers = Hash[@http_headers.map {|k,v| [k.gsub("{P}", payload), v.gsub("{P}", payload)]}]
			send_request(attack_uri, attack_data, payload_headers,payload)
		end
	end

	# 
	# Process the HTTP data and ship that off to the client.
	# 
	# Currently this does not store any responses
	#
	def send_request(http_uri=nil,http_data=nil, http_headers=nil,payload=nil)
		req = Mechanize.new.tap do |r|
			if @proxy_host
				r.set_proxy(@proxy_host, @proxy_port)
			end

			# Disabling verification.. we don't really care
			r.verify_mode = OpenSSL::SSL::VERIFY_NONE
		end

		# Set these if they weren't passed in...
		http_uri ||= @http_uri
		http_data ||= @http_data
		http_headers ||= @http_headers

		begin
			if @http_method.downcase == "get"
				response = req.get(http_uri, [], nil, http_headers)
			else
				response = req.post(http_uri, http_data, http_headers)
			end

			check_response_for_match(response.body, payload)

			store_response(response) if @attack_mode == 'store'
			@last_status_code = response.code.to_i
		rescue Exception => e
			puts "Unable to connect"
			puts e.inspect
			@last_status_code = 0
		end
	end

	def check_response_for_match(response, payload)
		@response_flag_meta.each do |metum|
			match_value = metum["match_value"]
			match_type = metum["match_type"]

			if match_type == "string"
				if response.include?(match_value)
					send_match_to_api(response, match_value, payload)
				end
			else
				pattern = Regexp.new(match_value)

				if response.match(pattern)
					send_match_to_api(response, match_value, payload)
				end
			end
		end
	end

	def store_response(response)
		endpoint = "#{@server}/job/#{@job_id}/saveResponse"

		headers = get_auth_headers
		data = { 
			:response 				=> Base64.encode64(response.body),
			:response_code 		=> response.code.to_i,
			:nodeid 					=> @node_id	
		}
		begin
			req = Mechanize.new.tap do |r|
				if @server.match(/^https/)  # enable SSL/TLS
				  r.agent.ca_file = @cert_path
				end
			end
			response = req.post(endpoint, data, headers)
		rescue
			puts "Failed sending response to api"
		end
	end

	def send_match_to_api(response, match_value, payload=nil) 
		endpoint = "#{@server}/job/#{@job_id}/saveMatch"

		headers = get_auth_headers
		data = { 
			:response 				=> Base64.encode64(response),
			:match_value			=> match_value,
			:payload 					=> payload,
			:nodeid 					=> @node_id	
		}

		puts "Sending match to server"
		begin
			req = Mechanize.new.tap do |r|
				if @server.match(/^https/)  # enable SSL/TLS
				  r.agent.ca_file = @cert_path
				end
			end
			response = req.post(endpoint, data, headers)
		rescue
			puts "Failed sending match to api"
		end
	end

	# Communicates with C&C behind the scenes to look for job status changes

	def monitor_job_status
		# Let's sleep for a bit first
		sleep(SLEEP_TIME)

		# check status code
		status_code = @last_status_code

		puts "Checking job status for job #{@job_id} on node #{@node_id}"

		# Todo: Refactor this to also send the most previous http status code
		endpoint = "#{@server}/checkin/#{@node_id}/#{@job_id}/#{status_code}"
		headers = get_auth_headers

		begin
			req = Mechanize.new.tap do |r|
				if endpoint.match(/^https/)  # enable SSL/TLS
				  r.agent.ca_file = @cert_path
				end
			end

			response = req.get(endpoint, [], nil, headers)

			# Basically checking if the payloads have been sent
			# This occurrs after checkin
			if @has_job == false
				return false
			end

			# Parse response
			response_parsed = JSON.parse(response.body)

			if response_parsed["status"] == "active"
				@has_job = true
			else
				@has_job = false
				return false
			end
		rescue Exception => e
			puts "unable to check status"
			puts e.inspect
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

			if @server.match(/^https/)  # enable SSL/TLS
			  r.agent.ca_file = @cert_path
			end
		end

		begin
			response = req.head(@server + "/health")
			if response.code.to_i >= 400
				puts "(!) Unable to communicate with command and control server"
				puts "(!) Please confirm address: #{@server}"
			else
				return true
			end
		rescue Exception => e
			puts "(!) Unable to communicate with command and control server"
			puts "(!) Please confirm address: #{@server}"
			return false
		end
	end

	def get_auth_headers
		# Auth Header
		headers = { "X-Node-Token" => @node_api_key}
	end

	def parse_work(work)
		return [] if work.nil?

		return URI.unescape(work).split("\n")
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

		lines.each do |line|
			split_line = line.split(":", 2)

			# Skip this line if it isn't splittable
			next if split_line.count < 2

			# Remove trailing whitespace
			split_line[1].chomp!
			
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
	    when /linux/
				$1 if output =~ /HWaddr.*?(([A-F0-9]{2}:){5}[A-F0-9]{2})/im
	    else nil
	  end
	end
end