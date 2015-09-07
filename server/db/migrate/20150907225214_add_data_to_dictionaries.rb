class AddDataToDictionaries < ActiveRecord::Migration
  def change
    add_column :dictionaries, :file_size, :integer
    add_column :dictionaries, :preview, :string
  end
end
