class AddJobResponseTable < ActiveRecord::Migration
  def change
    create_table :job_responses do |t|
      t.integer       :jobid
      t.integer       :nodeid
      t.integer       :code
      t.text          :response

      t.timestamps  null: false
    end

    add_column  :jobs, :attack_mode, :string
  end
end
