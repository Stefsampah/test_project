class CreateRewards < ActiveRecord::Migration[7.1]
  def change
    create_table :rewards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :badge_type, null: false
      t.integer :quantity_required, null: false
      t.string :reward_type, null: false
      t.string :reward_description
      t.boolean :unlocked, default: false
      t.datetime :unlocked_at

      t.timestamps
    end
    
    add_index :rewards, [:user_id, :badge_type, :quantity_required], unique: true, name: 'index_rewards_on_user_badge_quantity'
  end
end
