class DictionaryChunkAllocation < ActiveRecord::Base
	belongs_to :job
	belongs_to :node

	def self.nextChunkForJob(job_id)
		end_of_last_byte = self.where(:job_id => job_id).order(end_byte: :desc).first

		if end_of_last_byte.nil?
			return 0
		else
			return end_of_last_byte[:end_byte] + 1
		end
	end
end