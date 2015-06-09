class Node < ActiveRecord::Base
	def mark_active
		self.last_seen = DateTime.now
		self.save
	end

end