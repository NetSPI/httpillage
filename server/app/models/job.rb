class Job < ActiveRecord::Base
	attr_accessor	:work

  belongs_to :user

  has_many	:job_responses, :foreign_key => "jobid"
  has_many  :node_status_checkins, -> { order(created_at: :DESC) }
	has_many 	:dictionary_chunk_allocations
	has_one		:dictionary, :primary_key => "dictionary_id", :foreign_key => "id"

  has_many  :response_flag_meta, :class_name => "ResponseFlagMeta"
  has_many  :response_flags

	validates 	:http_method, inclusion: { in: ["GET", "POST", "PUT", "PATCH", "DELETE"]}
	
	validates 	:http_method, presence: true
	validates 	:http_uri, presence: true

	scope :active, -> { where(status: "active") }
end