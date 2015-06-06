class Job < ActiveRecord::Base
	scope :active, -> { where(status: "active") }
end