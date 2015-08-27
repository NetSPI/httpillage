class ChangeJobResponseNode < ActiveRecord::Migration
  def change
    change_column :job_responses, :nodeid, :text
  end
end
