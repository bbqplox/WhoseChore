class CreateGroupInvites < ActiveRecord::Migration
  def change
    create_table :group_invites do |t|
      t.integer :user_id      # This is recepient of invite
      t.integer :group_id
      t.timestamps null: false
      t.integer :sender_id
    end
  end
end
