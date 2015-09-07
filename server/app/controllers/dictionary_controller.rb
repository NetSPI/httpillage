class DictionaryController < ApplicationController
	def index
		@dictionaries ||= Dictionary.all
	end

	def show
		@dictionary = Dictionary.find(params[:dictionaryid])
		file_path = Rails.root.join('lib', 'dictionaries', @dictionary.filename)
		send_file file_path, :filename => @dictionary.original_filename, 
			:type=>"text/plain", :x_sendfile=>true
	end

	def new
		@dictionary ||= Dictionary.new
	end

	def create
		dictionary_file = params[:dictionary][:dictionary_file]

		# TODO: Error checking
		generated_name = generate_filename(dictionary_file.original_filename)
		file_path = Rails.root.join('lib', 'dictionaries', generated_name)
		File.open(file_path, 'wb') do |file|
			file.write(dictionary_file.read)
		end

		# Grab preview of dictionary
		total_lines = ""
		counter = 0

		opened_file = File.open(file_path, 'r')
		opened_file.each_line do |line|
			total_lines += line

			counter += 1
			break if counter == 20
		end

		# Grab filesize in bytes
		filesize = File.size(file_path)


		dictionary = Dictionary.create(
			{ 
				:filename 			=> generated_name,
				:original_filename	=> dictionary_file.original_filename,
				:description 		=> params[:dictionary][:description],
				:file_size  		=> filesize,
				:preview 				=> total_lines
			}
		)

		if dictionary.valid?
			flash[:notice] = "Dictionary Uploaded Successfully"
		else
			flash[:error] = dictionary.errors.messages
		end

		redirect_to dictionaries_path
	end

	def destroy
		@dictionary = Dictionary.find(params[:dictionaryid])

		file_path = Rails.root.join('lib', 'dictionaries', @dictionary.filename)

		@dictionary.destroy

		File.delete(file_path) if File.exist?(file_path)

		flash[:notice] = "Dictionary successfully removed"
		redirect_to dictionaries_path
	end

	private
	#
	# Compute a new filename for the uploaded file.
	#
	def generate_filename(filename)
		# Just some entropy to prevent collisions... not trying
		# to protect any information.
		filename = "#{filename}:#{SecureRandom.hex(10)}:#{Time.now}"

		digest = Digest::SHA256.new
		return digest.hexdigest filename
	end
end