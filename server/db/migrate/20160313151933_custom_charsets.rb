class CustomCharsets < ActiveRecord::Migration
  def change
    create_table :charsets do |t|
      t.string :key, index:true
      t.string :val
    end
  end
end
