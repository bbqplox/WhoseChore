class CreateHubs < ActiveRecord::Migration
  def change
    create_table :hubs do |t|

      t.timestamps null: false
      t.integer :user_id
    end
  end
end
