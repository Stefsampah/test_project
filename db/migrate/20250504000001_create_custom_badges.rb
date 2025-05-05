class CreateCustomBadges < ActiveRecord::Migration[6.0]
  def change
    # Vérifier si la table badges existe déjà
    unless table_exists?(:badges)
      create_table :badges do |t|
        t.string :name, null: false
        t.string :badge_type, null: false
        t.string :level, null: false
        t.integer :points_required, null: false
        t.text :description
        t.string :reward_type
        t.text :reward_description

        t.timestamps
      end
      
      add_index :badges, [:badge_type, :level], unique: true
    end

    # Vérifier si la table user_badges existe déjà
    unless table_exists?(:user_badges)
      create_table :user_badges do |t|
        t.references :user, null: false, foreign_key: true
        t.references :badge, null: false, foreign_key: true
        t.datetime :earned_at
        t.integer :points_at_earned
        t.datetime :claimed_at

        t.timestamps
      end
      
      add_index :user_badges, [:user_id, :badge_id], unique: true
    end
  end
end 