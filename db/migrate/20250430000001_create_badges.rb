class CreateBadges < ActiveRecord::Migration[7.1]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.string :badge_type, null: false  # competitor, engager, critic, challenger
      t.string :level, null: false      # bronze, silver, gold
      t.integer :points_required, null: false
      t.text :description
      t.string :icon_url
      t.string :reward_type            # standard, premium
      t.text :reward_description

      t.timestamps
    end

    add_index :badges, [:badge_type, :level], unique: true
  end
end 