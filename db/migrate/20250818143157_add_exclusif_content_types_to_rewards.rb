class AddExclusifContentTypesToRewards < ActiveRecord::Migration[7.1]
  def change
    # Ajouter les nouveaux types de contenu exclusif à l'enum content_type
    # Note: Rails gère automatiquement les nouveaux enum values, mais nous devons
    # nous assurer que la base de données peut accepter ces nouvelles valeurs
    
    # Vérifier si la colonne content_type existe et peut accepter les nouvelles valeurs
    if column_exists?(:rewards, :content_type)
      # Les nouveaux types de contenu seront automatiquement gérés par Rails
      # car ils sont définis dans le modèle Reward
      puts "Migration: Les nouveaux types de contenu exclusif ont été ajoutés au modèle Reward"
    else
      puts "Migration: La colonne content_type n'existe pas dans la table rewards"
    end
  end
end
