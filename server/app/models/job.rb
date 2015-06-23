class Job < ActiveRecord::Base
	validates :http_method, inclusion: { in: ["GET", "POST", "PUT", "PATCH", "DELETE"]}
	
	validates :http_method, presence: true
	validates :http_uri, presence: true

	scope :active, -> { where(status: "active") }
end