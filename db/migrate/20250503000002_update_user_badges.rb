class UpdateUserBadges < ActiveRecord::Migration[6.1]
  def change
    # La table user_badges existe déjà, on va juste renommer la colonne reward_claimed_at en claimed_at
    # et ajouter d'autres modifications si nécessaire
    
    # Vérifions d'abord si la colonne reward_claimed_at existe
    if column_exists?(:user_badges, :reward_claimed_at)
      rename_column :user_badges, :reward_claimed_at, :claimed_at
    end
    
    # Si la colonne reward_claimed existe, la renommer ou la supprimer si claimed_at existe déjà
    if column_exists?(:user_badges, :reward_claimed) && !column_exists?(:user_badges, :claimed_at)
      add_column :user_badges, :claimed_at, :datetime
    end
  end
end 