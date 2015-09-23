class Job < ActiveRecord::Base
	attr_accessor	:work

  belongs_to :user

  has_many	:job_responses, :foreign_key => "jobid"
  has_many  :node_status_checkins, -> { order(created_at: :DESC) }
	has_many 	:dictionary_chunk_allocations
	has_one		:dictionary, :primary_key => "dictionary_id", :foreign_key => "id"

	validates 	:http_method, inclusion: { in: ["GET", "POST", "PUT", "PATCH", "DELETE"]}
	
	validates 	:http_method, presence: true
	validates 	:http_uri, presence: true

	scope :active, -> { where(status: "active") }
end