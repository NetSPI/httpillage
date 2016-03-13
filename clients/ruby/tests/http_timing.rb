require 'mechanize'# This is a simple test to determine times for threaded HTTP requests
require 'net/http'

thread_count = 5

# We're going to assume 1,000 requests
request_count = 100

# Temporary URL for testing
target_url = "http://127.0.0.1:3000"

@has_job = true

def send_request(http_uri=nil,http_data=nil, http_headers=nil,payload=nil)
 #uri = URI('http://127.0.0.1:3000/')
 #Net::HTTP.get(uri)
 #Net::HTTP.post_form(uri, 'user[email]' => 'ruby', 'user[password]' => '50')
begin 
  begin
    req = Mechanize.new
    response = req.post("http://127.0.0.1:3000/users/sign_in", URI.decode_www_form("user[email]=ruby&user[password]=50"))
    #response = req.get("http://127.0.0.1:3000", [], nil, nil)
  rescue Exception => e
  end
end
end

time_before = Time.now
puts "Starting at: #{time_before}"

job_threads = (1..thread_count).map do |i|
  Thread.new(i) do |i|
    while @has_job
      # Ideally we would check if process_request returns done
      # If it does, let the C&C know...
      res = send_request(target_url, nil, nil)
      request_count -= 1

      if request_count <= 0
        @has_job = false
      end
    end
  end
end

job_threads.each {|t| t.join }

time_after = Time.now
puts "Ending at: #{time_after}"

elapsed_time = (time_after - time_before).to_i

puts "Completed in #{elapsed_time} seconds"