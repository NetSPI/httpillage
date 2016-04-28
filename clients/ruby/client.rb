	# encoding: utf-8
	require './lib/cnc'
	require './lib/helpers'
	require 'net/http'
	include Logging

	SLEEP_TIME = 3

	# Limit for match delivery queue
	QUEUE_LIMIT = 100

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

			@delivery_queue = []
		end

		def invoke
			# Make sure we can reach C&C
			cc_server_reachable = false
			while cc_server_reachable == false
				cc_server_reachable = cc_stability_test
			end

			logger.info "(+) Polling for Job..."
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
			@temp_thread_count = 0


			@bruteforce_index = job["next_index"]
			if @job_type == "dictionary"
				@attack_payloads 	= parse_work(job["work"])
			elsif @job_type == "bruteforce"
				@charset = job["charset"]
				charsets = get_charsets

				initiateKeyspaceDict(charsets)

				@attack_payloads = generateSubkeyspace(@charset, @bruteforce_index, 50)
			end

			@response_flag_meta = job["response_flag_meta"]

			# If the job type is repeat without response_flag_meta, set threads to 100
			if @job_type == "repeat" && (@response_flag_meta.nil? || @response_flag_meta.count == 0)
				logger.info "(+) DoS attack detected. Increasing thread count"
				@temp_thread_count = 500
			end

			logger.info "Work: #{@attack_payloads}"
			kick_off_job!
		end

		# Everything is called via invoke
		private
		def request_job
			endpoint = @server + "/poll/#{@node_id}"

			headers = get_auth_headers
			logger.info "Requesting Job"

			req = CNC::Request.new(cnc_options)

			begin
				response = req.get(endpoint, {}, nil, headers)
			rescue Exception => e
				logger.error "Unable to connect to CNC"
				logger.error "Endpoint: \t #{endpoint}"
				logger.error "Stack trace: \t #{e.inspect}"
			end

			# Parse response

			unless response.nil? || response.body.nil?
				response_parsed = JSON.parse(response.body)
			
				if response_parsed["status"] == "active"
					return response_parsed
				end
			end
			# Failed, but let's sleep
			logger.info "Sleeping for #{SLEEP_TIME} seconds"
			sleep(SLEEP_TIME)
			return false
		end

		def kick_off_job!
			if @temp_thread_count > 0
				thread_count = @temp_thread_count
			else
				thread_count = @thread_count.to_i
			end

			logger.info "(+) Job recieved. Kicking it off with #{thread_count} threads"
			logger.info "(+) Currently attacking: #{@http_uri}"


			monitor_thread_id = thread_count + 1

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

			logger.info "(+) Job has been stopped by C&C"
			logger.info "(+) Beginning search for new job"
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
=begin			
			req = Mechanize.new.tap do |r|
				if @proxy_host
					r.set_proxy(@proxy_host, @proxy_port)
				end

				# Disabling verification.. we don't really care
				r.verify_mode = OpenSSL::SSL::VERIFY_NONE
			end
=end


			# Set these if they weren't passed in...
			http_uri ||= @http_uri
			http_data ||= @http_data
			http_headers ||= @http_headers

			begin
				uri = URI(http_uri)

				if @http_method.downcase == "get"
					req = Net::HTTP::Get.new(uri.path)
				else
					req = Net::HTTP::Post.new(uri.path)
					req.set_form_data(http_data)
				end

				http_headers.each do |k,v|
					req[k] = v
				end

				response = Net::HTTP.start(uri.hostname, uri.port) do |http|
				  http.request(req)
				end

				# Let's ignore unless there are matches
				unless @response_flag_meta.nil?
					check_response_for_match(response, payload)
				end

				store_response(response) if @attack_mode == 'store'
				@last_status_code = response.code.to_i
			rescue Exception => e
				logger.error "Unable to connect to client"
				logger.error e.inspect
				@last_status_code = 0
			end
		end

		# This is used to build the raw HTTP response from mechanize
		def build_response_from_body_and_headers(headers, body) 
			header_str = ""
			headers.each do |header, val|
				header_str += "#{header}: "

				if val.length > 1 
					header_str += "#{val.join(', ')}"
				else
						header_str += "#{val[0]}"
				end
				header_str += "\n"
			end

			return "#{header_str}\n#{body}"
		end

		def check_response_for_match(response, payload)
			response_headers = response.to_hash
			response_body = response.body

			response = build_response_from_body_and_headers(response_headers, response_body)

			@response_flag_meta.each do |metum|
				match_value = metum["match_value"]
				match_type = metum["match_type"]
				match_delivery = metum["match_delivery"]

				if match_type == "string"
					if response.include?(match_value)
						# Either send directly to API, or queue up
						if metum["match_delivery"].nil? || metum["match_delivery"] == "instant"
							send_match_to_api(response, match_value, payload)
						else
							# Queue
							queue_match_for_bulk_delivery(response, match_value, payload)
						end
					end
				else
					pattern = Regexp.new(match_value)
					matches = response.scan(pattern)

					matches.each do |match|
						if metum["match_delivery"].nil? || metum["match_delivery"] == "instant"
							send_match_to_api(response, match, payload, match_value)
						else
							# Queue
							queue_match_for_bulk_delivery(nil, match, payload, match_value)
						end
					end
				end
			end
		end

		def queue_match_for_bulk_delivery(response, match, payload=nil, match_value=nil)
			@delivery_queue.push({ 
				:response => response, 
				:match => match, 
				:payload => payload, 
				:match_value => match_value,
				:match_time	=> DateTime.now
			})

			# Send all results, once queue is over the limit
			if @delivery_queue.count >= QUEUE_LIMIT
				# Duplicate it, clean it, and operate on dup
				queue = @delivery_queue.dup
				@delivery_queue = []
				logger.info "Sending bulk matches to server"

				endpoint = "#{@server}/job/#{@job_id}/saveMatchBatch"

				headers = get_auth_headers

				data = { "matches": queue.to_json }

				logger.info "Sending match to server"
				begin
					req = CNC::Request.new(cnc_options)
					response = req.post(endpoint, data, headers)
				rescue
					logger.error "Failed sending bulk matches to api"
					logger.error endpoint
					logger.error data
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
				req = CNC::Request.new(cnc_options)
				response = req.post(endpoint, data, headers)
			rescue
				logger.error "Failed sending response to api"
				logger.error endpoint
				logger.error data
			end
		end

		def send_match_to_api(response, match, payload=nil, match_value=nil) 
			endpoint = "#{@server}/job/#{@job_id}/saveMatch"

			headers = get_auth_headers
			response_string = @attack_mode == 'store' ? response.body : "";
			data = { 
				:response 				=> Base64.encode64(response_string),
				:match_value			=> match,
				:payload 					=> payload,
				:nodeid 					=> @node_id	
			}

			logger.info "Sending match to server"
			begin
				req = CNC::Request.new(cnc_options)
				response = req.post(endpoint, data, headers)
			rescue
				logger.error "Failed sending match to api"
				logger.error endpoint
				logger.error data
			end
		end

		# Communicates with C&C behind the scenes to look for job status changes

		def monitor_job_status
			# Let's sleep for a bit first
			sleep(SLEEP_TIME)

			# check status code
			status_code = @last_status_code

			logger.info "Checking job status for job #{@job_id} on node #{@node_id}"

			# Todo: Refactor this to also send the most previous http status code
			endpoint = "#{@server}/checkin/#{@node_id}/#{@job_id}/#{status_code}"
			headers = get_auth_headers

			begin
				req = CNC::Request.new(cnc_options)

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
				logger.error "unable to check status"
				logger.error e.inspect
				# Ehh, let it slide for now.
				# Eventually there should be an error counter that kills
				# jobs based on a certain number of unsuccessful attempts
			end
		end

		def cc_stability_test
			req = CNC::Request.new(cnc_options)

			begin
				response = req.head(@server + "/health")
				if response.code.to_i >= 400
					logger.error "(!) Unable to communicate with command and control server"
					logger.error "(!) Please confirm address: #{@server}"
					logger.error "(!) Code: #{response.code.to_s}"
					return false
				else
					return true
				end
			rescue Exception => e
				logger.error "#{e.inspect}"
				logger.error "(!) Unable to communicate with command and control server"
				logger.error "(!) Please confirm address: #{@server}"
				return false
			end
		end

		def get_charsets
			# this is a mock for now
			req = CNC::Request.new(cnc_options)

			begin
				response = req.get(@server + "/charsets")
				charsets = JSON.parse(response.body)

				charsets_hash = { }
				charsets.each do |charset|
					charsets_hash[charset["key"]] = charset["val"]
				end

				return charsets_hash
			rescue Exception => e
				logger.error "#{e.inspect}"
				logger.error "(!) Unable to retrive charaset"
				return false
			end
		end

		def get_auth_headers
			# Auth Header
			headers = { "X-Node-Token" => @node_api_key}
		end

		def cnc_options
			{
				:server 				=> @server,
				:proxy_host			=> @proxy_host,
				:proxy_port 		=> @proxy_port,
				:cert_path			=> @cert_path,
				:api_key 				=> @node_api_key
			}
		end
	end