# 🏆 Concern pour déclencher les animations de badges

module BadgeAnimationTrigger
  extend ActiveSupport::Concern

  included do
    after_create :trigger_badge_animation
  end

  private

  # 🎯 Déclencher l'animation si un badge vient d'être débloqué
  def trigger_badge_animation
    return unless earned_at.present?
    
    # Déclencher l'animation via JavaScript
    trigger_badge_unlock_animation
  end

  # 🎊 Déclencher l'animation de déblocage de badge
  def trigger_badge_unlock_animation
    # Créer les données d'animation
    animation_data = {
      type: 'badge',
      title: badge.name,
      description: get_badge_animation_description,
      level: badge.level,
      badge_type: badge.badge_type,
      points_required: badge.points_required,
      reward_type: badge.reward_type
    }

    # Stocker les données pour le frontend
    Rails.cache.write("badge_animation_#{user_id}_#{id}", animation_data, expires_in: 1.hour)
    
    # Déclencher l'événement JavaScript
    broadcast_badge_animation(animation_data)
  end

  # 📝 Obtenir la description pour l'animation de badge
  def get_badge_animation_description
    case badge.badge_type
    when 'competitor'
      "🏆 Vous êtes un vrai compétiteur ! Continuez à jouer pour débloquer plus de badges."
    when 'engager'
      "🎮 Vous vous engagez dans le jeu ! Votre participation est remarquable."
    when 'critic'
      "🎯 Vous avez un œil critique ! Vos opinions comptent dans la communauté."
    when 'challenger'
      "⚡ Vous relevez tous les défis ! Vous êtes un champion du jeu."
    else
      "🏅 Nouveau badge débloqué ! Continuez à jouer pour en débloquer d'autres."
    end
  end

  # 📡 Diffuser l'animation via ActionCable (si configuré)
  def broadcast_badge_animation(animation_data)
    # Pour l'instant, on stocke juste les données
    # Plus tard, on pourra utiliser ActionCable pour diffuser en temps réel
    Rails.logger.info "🎉 Badge animation triggered: #{animation_data[:title]} for user #{user_id}"
  end
end
