class CreateSettingsTable < ActiveRecord::Migration
  def change
    create_table :settings_tables do |t|
      t.string :key, index:true
      t.string :val
    end
  end
end
