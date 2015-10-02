class ResponseFlagging < ActiveRecord::Migration
  def change
    create_table :response_flag_meta do |t|
      t.belongs_to  :job, index:true
      t.string      :match_type
      t.string      :match_value

      t.timestamps  null: false
    end

    create_table :response_flags do |t|
      t.belongs_to  :job, index:true
      t.belongs_to  :node, index:true
      t.string      :http_request
      t.string      :http_response
      t.string      :matched_string
      t.string      :payload

      t.timestamps  null: false
    end

  end
end
