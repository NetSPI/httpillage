class ResponseFlag < ActiveRecord::Base
  require 'csv'
  belongs_to :job
  belongs_to :node

  def self.matches_since_timestamp(jobid,timestamp)
    timestamp = DateTime.parse(timestamp)
    self.where(job_id: jobid).where("created_at > ?", timestamp)
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end 
    end
  end
end