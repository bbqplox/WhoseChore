class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|

      t.timestamps null: false
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :email

    end
  end
end
