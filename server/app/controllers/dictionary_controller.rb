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
		File.open(Rails.root.join('lib', 'dictionaries', generated_name), 'wb') do |file|
			file.write(dictionary_file.read)
		end

		dictionary = Dictionary.create(
			{ 
				:filename 			=> generated_name,
				:original_filename	=> dictionary_file.original_filename,
				:description 		=> params[:dictionary][:description]
			}
		)

		flash[:notice] = "Post successfully created"

		render action: :index
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
		return digest.hexdigest 'filename'
	end
end