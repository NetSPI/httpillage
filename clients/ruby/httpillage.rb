# Once the script is invoked, continuously poll for new jobs until one is
# provided. After which, spin up N extra threads, while continuously polling
# in the foreground.

require 'mechanize'
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
		# TODO: Refactor this to set logging verbosity level
	end

	options[:threads] = 5
	opts.on('-t', '--threads THREADS', 'Number of threads to leverage') do |threads|
		options[:threads] = threads
	end

	options[:server] = "http://127.0.0.1:3000"
	opts.on('-s', '--server SERVER', 'Address of C&C server') do |server|
		options[:server] = server
	end

	options [:proxy_host] = false
	opts.on('--proxy-host PROXY', 'Proxy Host / IP: (127.0.0.1)') do |proxy|
		options[:proxy_host] = proxy
	end

	options [:proxy_port] = false
	opts.on('--proxy-port PORT', 'Proxy Port (8080)') do |port|
		options[:proxy_port] = port
	end

	options [:node_api_key] = ""
	opts.on('--api-key KEY', 'API Key for Nodes') do |key|
		options[:node_api_key] = key
	end

	options [:cert_path] = ""
	opts.on('--cert-path PATH', 'Path for .crt/.cer file for verification') do |path|
		options[:cert_path] = path
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


client = Client.new(options[:server], options[:threads], options[:proxy_host], options[:proxy_port], options[:node_api_key], options[:cert_path])
client.invoke