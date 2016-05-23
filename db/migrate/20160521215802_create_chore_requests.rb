class CreateChoreRequests < ActiveRecord::Migration
  def change
    create_table :chore_requests do |t|
      t.integer :user_id      # This is recepient of invite
      t.integer :chore_id
      t.integer :sender_id
      t.timestamps null: false
    end
  end
end
