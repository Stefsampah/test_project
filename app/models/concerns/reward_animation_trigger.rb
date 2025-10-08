# 🎉 Concern pour déclencher les animations de récompenses

module RewardAnimationTrigger
  extend ActiveSupport::Concern

  included do
    after_update :trigger_animation_if_unlocked, if: :saved_change_to_unlocked?
  end

  private

  # 🎯 Déclencher l'animation si la récompense vient d'être débloquée
  def trigger_animation_if_unlocked
    return unless unlocked? && unlocked_at.present?
    
    # Déclencher l'animation via JavaScript
    trigger_reward_animation
  end

  # 🎊 Déclencher l'animation de récompense
  def trigger_reward_animation
    # Créer les données d'animation
    animation_data = {
      type: reward_type.humanize,
      title: reward_description,
      description: get_animation_description,
      level: reward_type,
      points: quantity_required,
      content_type: content_type
    }

    # Stocker les données pour le frontend
    Rails.cache.write("reward_animation_#{user_id}_#{id}", animation_data, expires_in: 1.hour)
    
    # Déclencher l'événement JavaScript
    broadcast_reward_animation(animation_data)
  end

  # 📝 Obtenir la description pour l'animation
  def get_animation_description
    case reward_type
    when 'challenge'
      "Vous avez débloqué une playlist exclusive ! Continuez à jouer pour plus de récompenses."
    when 'exclusif'
      "Accès à du contenu premium spécial ! Découvrez des playlists uniques et du contenu exclusif."
    when 'premium'
      "Contenu VIP et rencontres avec artistes ! Vous avez accès aux meilleures récompenses."
    when 'ultime'
      "Récompense ultime - vous êtes un champion ! Accès à tout le contenu premium."
    else
      "Nouvelle récompense disponible ! Continuez à jouer pour en débloquer d'autres."
    end
  end

  # 📡 Diffuser l'animation via ActionCable (si configuré)
  def broadcast_reward_animation(animation_data)
    return unless defined?(ActionCable)
    
    begin
      ActionCable.server.broadcast(
        "reward_animations_#{user_id}",
        {
          type: 'reward_unlocked',
          data: animation_data,
          timestamp: Time.current.to_i
        }
      )
    rescue => e
      Rails.logger.error "Erreur lors de la diffusion de l'animation: #{e.message}"
    end
  end

  # 🎮 Méthode de classe pour déclencher une animation de test
  def self.trigger_test_animation(user, reward_type = 'challenge')
    return unless user.present?
    
    # Créer une récompense de test temporaire
    test_reward = new(
      user: user,
      reward_type: reward_type,
      badge_type: 'unified',
      quantity_required: get_quantity_for_type(reward_type),
      reward_description: "Récompense #{reward_type.humanize} de test",
      content_type: "test_#{reward_type}",
      unlocked: true,
      unlocked_at: Time.current
    )
    
    # Déclencher l'animation
    test_reward.trigger_reward_animation
  end

  # 📊 Obtenir la quantité requise pour un type de récompense
  def self.get_quantity_for_type(type)
    case type
    when 'challenge' then 3
    when 'exclusif' then 6
    when 'premium' then 9
    when 'ultime' then 12
    else 3
    end
  end
end
