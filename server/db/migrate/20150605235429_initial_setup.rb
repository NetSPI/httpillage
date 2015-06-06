class InitialSetup < ActiveRecord::Migration
  def change
  	create_table :nodes do |t|
  	  t.string		:ip_addr
  	  t.datetime	:last_seen
  	  t.string		:name

  	  t.timestamps 	null: false
  	end

    create_table :jobs do |t|
  	  t.string		:http_method
  	  t.string		:http_uri
  	  t.string		:http_host
  	  t.text		:http_headers
  	  t.text		:http_data
  	  t.string		:attack_type
  	  t.string		:status

  	  t.timestamps	null: false
    end
  end
end
