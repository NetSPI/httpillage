class DictionaryPreviewToText < ActiveRecord::Migration
  def change
    change_column :dictionaries, :preview, :text
  end
end
