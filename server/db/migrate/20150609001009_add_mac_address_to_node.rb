class AddMacAddressToNode < ActiveRecord::Migration
  def change
  	add_column	:nodes, :mac_address, :string
  	add_index	:nodes, :mac_address
  end
end
