class UserHasJobs < ActiveRecord::Migration
  def change
    change_table :jobs do |t|
      t.belongs_to :user, index: true
    end
  end
end
