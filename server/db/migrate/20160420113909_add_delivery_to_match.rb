class AddDeliveryToMatch < ActiveRecord::Migration
  def change
    change_table :response_flag_meta do |t|
      t.string :match_delivery
    end
  end
end
