class DictionaryFiles < ActiveRecord::Migration
  def change
  	create_table :dictionaries do |t|
  	  t.string		:filename
  	  t.string		:original_filename
  	  t.text		:description

  	  t.timestamps 	null: false
  	end
  end
end
