# Once the script is invoked, continuously poll for new jobs until one is
# provided. After which, spin up N extra threads, while continuously polling
# in the foreground.

require 'mechanize'
require 'celluloid'
require 'optparse'
require 'json'
require 'base64'
require './client.rb'

options = {}

optparse = OptionParser.new do |opts|
	opts.banner = "Usage: httpillage.rb"

	options[:verbose] = false
	opts.on('-v', '--verbose', 'Output verbose information pertaining to ' +
		'the HTTP requests and job status') do
		options[:verbose] = true
	end

	options[:threads] = 3
	opts.on('-t', '--threads THREADS', 'Number of threads to leverage') do |threads|
		options[:threads] = threads
	end

	options[:server] = "http://127.0.0.1:3000"
	opts.on('-s', '--server SERVER', 'Address of C&C server') do |server|
		options[:server] = server
	end

	opts.on('-h', '--help', 'Display this screen') do 
		puts opts
		exit
	end
end

optparse.parse!

puts "Being verbose" if options[:verbose]
puts "Executing with number of threads: #{options[:threads]}"
puts "Command and control server: #{options[:server]}"


client = Client.new(options[:server], options[:threads])
client.invoke