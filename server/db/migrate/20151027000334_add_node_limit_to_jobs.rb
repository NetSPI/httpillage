class AddNodeLimitToJobs < ActiveRecord::Migration
  def change
    change_table :jobs do |t|
      t.integer :node_limit, index: true
    end
  end
end
