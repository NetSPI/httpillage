class NodeStatusCheckin < ActiveRecord::Base
  def self.checkins_since_timestamp(jobid,timestamp)
    timestamp = DateTime.parse(timestamp)
    self.where(job_id: jobid).where("created_at > ?", timestamp)
  end
end