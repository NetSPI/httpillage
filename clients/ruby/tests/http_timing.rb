require 'mechanize'# This is a simple test to determine times for threaded HTTP requests
require 'net/http'

@thread_count = 10

# We're going to assume 1,000 requests
@request_count = 1000

# Temporary URL for testing
@target_url = "http://52.23.237.18/wordpress/wp-login.php"

@has_job = true

def send_net_request
 uri = URI(@target_url)
 Net::HTTP.post_form(uri, 'log' => 'asdf', 'pwd' => 'asdf', 'wp-submit' => 'Log+In', 'redirect_to' => 'http%3A%2F%2F52.23.237.18%2Fwordpress%2Fwp-admin%2F', 'testcookie' => '1')
end

def send_mech_request
  begin
    req = Mechanize.new
    response = req.post(@target_url, URI.decode_www_form("log=asdf&pwd=adsf&wp-submit=Log+In&redirect_to=http%3A%2F%2F52.23.237.18%2Fwordpress%2Fwp-admin%2F&testcookie=1"))
  rescue Exception => e
  end
end

def mechanize_test
  tmp_request_count = @request_count
  time_before = Time.now
  puts "Starting at: #{time_before}"

  job_threads = (1..@thread_count).map do |i|
    Thread.new(i) do |i|
      while @has_job
        # Ideally we would check if process_request returns done
        # If it does, let the C&C know...
        res = send_mech_request
        tmp_request_count -= 1

        if tmp_request_count <= 0
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
end

def net_test
  tmp_request_count = @request_count
  time_before = Time.now
  puts "Starting at: #{time_before}"

  job_threads = (1..@thread_count).map do |i|
  Thread.new(i) do |i|
    while @has_job
      # Ideally we would check if process_request returns done
      # If it does, let the C&C know...
      res = send_net_request
      tmp_request_count -= 1

      if tmp_request_count <= 0
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
end

puts "Starting mechanize_test:"
#mechanize_test

puts "Starting Net::Http test:"
net_test