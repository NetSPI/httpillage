class AddCharsetToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :charset, :string
    add_column :jobs, :current_bruteforce_value, :string

    create_table :bruteforce_status do |t|
      t.integer     :node_id
      t.integer     :job_id
      t.string      :charset

      t.timestamps  null: false
    end
  end
end
