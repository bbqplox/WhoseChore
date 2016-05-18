class CreateRewardpunishments < ActiveRecord::Migration
  def change
    create_table :rewardpunishments do |t|
      t.string :title
      t.text :description
      t.boolean :rorp
      t.integer :value

      t.timestamps null: false
    end
  end
end
