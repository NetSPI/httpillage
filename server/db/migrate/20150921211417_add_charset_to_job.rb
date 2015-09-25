class AddCharsetToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :charset, :string
    add_column :jobs, :next_index, :integer

    create_table :bruteforce_statuses do |t|
      t.integer     :node_id
      t.integer     :job_id
      t.integer     :index

      t.timestamps  null: false
    end
  end
end
