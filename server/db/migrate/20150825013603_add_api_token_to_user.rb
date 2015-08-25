class AddApiTokenToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :api_token, index: true
      t.datetime  :api_token_changed
    end
  end
end
