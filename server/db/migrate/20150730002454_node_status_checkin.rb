class NodeStatusCheckin < ActiveRecord::Migration
  def change
  	create_table :node_status_checkins do |t|
  	  t.integer			:node_id
  	  t.integer			:job_id
  	  t.integer			:response_code

  	  t.timestamps 	null: false
  	end
  end
end
