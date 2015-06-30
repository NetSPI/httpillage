class Job < ActiveRecord::Base
	attr_accessor	:work

	has_many :dictionary_chunk_allocations
	validates :http_method, inclusion: { in: ["GET", "POST", "PUT", "PATCH", "DELETE"]}
	
	validates :http_method, presence: true
	validates :http_uri, presence: true

	scope :active, -> { where(status: "active") }
end