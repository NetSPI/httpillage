class CreateSettingsTable < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :key, index:true
      t.string :val
    end
  end
end
