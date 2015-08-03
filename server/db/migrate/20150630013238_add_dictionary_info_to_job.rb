class AddDictionaryInfoToJob < ActiveRecord::Migration
  def change
  	  create_table :dictionary_chunk_allocations do |t|
  	  	  t.belongs_to	:job, index:true
  	  	  t.belongs_to	:node, index:true

  	  	  # May run into integer overflow issues
	  	  t.integer		:start_byte
	  	  t.integer		:end_byte
	  	  t.boolean		:completed

	  	  t.timestamps 	null: false
	  	end

	  	add_column	:jobs, :dictionary_id, :integer
  end
end
